#!/usr/bin/env ruby
require 'tk'
root = TkRoot.new do
  title "Ruby/Tk Test"
end
Tk.mainloop

# frozen_string_literal: true

require_relative 'tk/ext/tk/tkutil/extconf'
require_relative 'tk/ext/tk/old-extconf'
require_relative 'tk/ext/tk/extconf'
require_relative 'tk/lib/tk'
require_relative 'tk/lib/tkafter'
require_relative 'tk/lib/tcltk'
require_relative 'tk/lib/tkclass'
require_relative 'tk/lib/multi-tk'
require_relative 'tk/lib/tkfont'
require_relative 'tk/lib/remote-tk'
require_relative 'tk/lib/tkentry'
require_relative 'tk/lib/tkbgerror'
require_relative 'tk/lib/tktext'
require_relative 'tk/lib/tkcanvas'
require_relative 'tk/lib/tkconsole'
require_relative 'tk/lib/tkdialog'
require_relative 'tk/lib/tkmacpkg'
require_relative 'tk/lib/tkmenubar'
require_relative 'tk/lib/tkpalette'
require_relative 'tk/lib/tkmngfocus'
require_relative 'tk/lib/tkwinpkg'
require_relative 'tk/lib/tkscrollbox'
require_relative 'tk/lib/tkvirtevent'
require_relative 'tk/lib/tk/text'
require_relative 'tk/lib/tk/button'
require_relative 'tk/lib/tk/label'
require_relative 'tk/lib/tk/message'
require_relative 'tk/Rakefile'
require_relative 'tk/tk.gemspec'
require_relative 'tk/Gemfile'
require_relative 'tcltklib'
require 'tcltkip'



