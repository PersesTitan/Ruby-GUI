# frozen_string_literal: false
#
#  tkextlib/tkDND/tkdnd.rb
#                               by Hidetoshi NAGAI (nagai@ai.kyutech.ac.jp)
#

require 'tk'

# call setup script for general 'tkextlib' libraries
require 'tkextlib/setup.rb'

# call setup script
require 'tkextlib/tkDND/setup.rb'

TkPackage.require('tkdnd')

module Tk
  module TkDND
    PACKAGE_NAME = 'tkdnd'.freeze
    def self.package_name
      PACKAGE_NAME
    end

    def self.package_version
      begin
        TkPackage.require('tkdnd')
      rescue
        ''
      end
    end

    class DND_Subst < TkUtil::CallbackSubst
      KEY_TBL = [
        [ ?a, ?l, :actions ],
        [ ?A, ?s, :action ],
        [ ?b, ?L, :codes ],
        [ ?c, ?s, :code ],
        [ ?d, ?l, :descriptions ],
        [ ?D, ?l, :data ],
        [ ?L, ?l, :source_types ],
        [ ?m, ?l, :modifiers ],
        [ ?t, ?l, :types ],
        [ ?T, ?s, :type ],
        [ ?W, ?w, :widget ],
        [ ?x, ?n, :x ],
        [ ?X, ?n, :x_root ],
        [ ?y, ?n, :y ],
        [ ?Y, ?n, :y_root ],
        nil
      ]

      PROC_TBL = [
        [ ?n, TkComm.method(:num_or_str) ],
        [ ?s, TkComm.method(:string) ],
        [ ?l, TkComm.method(:list) ],
        [ ?L, TkComm.method(:simplelist) ],
        [ ?w, TkComm.method(:window) ],
        nil
      ]

=begin
      # for Ruby m17n :: ?x --> String --> char-code ( getbyte(0) )
      KEY_TBL.map!{|inf|
        if inf.kind_of?(Array)
          inf[0] = inf[0].getbyte(0) if inf[0].kind_of?(String)
          inf[1] = inf[1].getbyte(0) if inf[1].kind_of?(String)
        end
        inf
      }

      PROC_TBL.map!{|inf|
        if inf.kind_of?(Array)
          inf[0] = inf[0].getbyte(0) if inf[0].kind_of?(String)
        end
        inf
      }
=end

      # setup tables
      _setup_subst_table(KEY_TBL, PROC_TBL);
    end

    class DND_SubstText < TkUtil::CallbackSubst
      KEY_TBL = [
        [ ?D, ?d, :data ],
        nil
      ]

      PROC_TBL = [
        [ ?d, proc do |s|
                case TclTkLib::WINDOWING_SYSTEM
                when 'x11', 'win32'
                  s.force_encoding('utf-8')
                end
                s
              end
        ],
        nil
      ]
      _setup_subst_table(KEY_TBL, PROC_TBL);
    end
    
    class DND_SubstFileList < TkUtil::CallbackSubst
      KEY_TBL = [
        [ ?D, ?d, :data ],
        nil
      ]

      PROC_TBL = [
        [ ?d, proc do |s|
                case TclTkLib::WINDOWING_SYSTEM
                when 'win32'
                  s.force_encoding('utf-8')
                  TkComm.simplelist(s).map { |x| x.tr('\\', '/') }
                when 'x11'
                  s = s.encode('iso8859-1', 'utf-8')
                  s.force_encoding('utf-8')
                  TkComm.simplelist(s)
                else
                  TkComm.simplelist(s)
                end
              end
        ],
        nil
      ]
      _setup_subst_table(KEY_TBL, PROC_TBL);
    end
    
    
    module DND
      def self.version
        begin
          TkPackage.require('tkdnd')
        rescue
          ''
        end
      end

      def dnd_bindtarget_info(type=nil, event=nil)
        if event
          procedure(tk_call('dnd', 'bindtarget', @path, type, event))
        elsif type
          procedure(tk_call('dnd', 'bindtarget', @path, type))
        else
          simplelist(tk_call('dnd', 'bindtarget', @path))
        end
      end

      def dnd_bindtarget(type, event, *args, &block)
        # if args[0].kind_of?(Proc) || args[0].kind_of?(Method)
        klass = case type
                when 'text/plain'
                  DND_SubstText
                when 'text/uri-list'
                  DND_SubstFileList
                else
                  DND_Subst
                end
        if TkComm._callback_entry?(args[0]) || !block
          cmd = args.shift
        else
          cmd = block
        end

        prior = 50
        prior = args.shift unless args.empty?

        event = tk_event_sequence(event)
        if prior.kind_of?(Numeric)
          tk_call('dnd', 'bindtarget', @path, type, event,
                  install_bind_for_event_class(klass, cmd, *args),
                  prior)
        else
          tk_call('dnd', 'bindtarget', @path, type, event,
                  install_bind_for_event_class(klass, cmd, prior, *args))
        end
        self
      end

      def dnd_cleartarget
        tk_call('dnd', 'cleartarget', @path)
        self
      end

      def dnd_bindsource_info(type=nil)
        if type
          procedure(tk_call('dnd', 'bindsource', @path, type))
        else
          simplelist(tk_call('dnd', 'bindsource', @path))
        end
      end

      def dnd_bindsource(type, *args, &block)
        # if args[0].kind_of?(Proc) || args[0].kind_of?(Method)
        if TkComm._callback_entry?(args[0]) || !block
          cmd = args.shift
        else
          cmd = block
        end

        args = [TkComm::None] if args.empty?

        tk_call('dnd', 'bindsource', @path, type, cmd, *args)
        self
      end

      def dnd_clearsource()
        tk_call('dnd', 'clearsource', @path)
        self
      end

      def dnd_drag(keys=nil)
        tk_call('dnd', 'drag', @path, *hash_kv(keys))
        self
      end
    end
  end
end

class TkWindow
  include Tk::TkDND::DND
end
