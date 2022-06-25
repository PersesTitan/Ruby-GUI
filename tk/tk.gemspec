Gem::Specification.new do |spec|
  spec.name          = "tk"
  spec.version       = "0.4.0"
  spec.authors       = ["SHIBATA Hiroshi", "Nobuyoshi Nakada", "Jeremy Evans"]
  spec.email         = ["hsbt@ruby-lang.org", "nobu@ruby-lang.org", "code@jeremyevans.net"]

  spec.summary       = %q{Tk interface module using tcltklib.}
  spec.description   = %q{Tk interface module using tcltklib.}
  spec.homepage      = "https://github.com/ruby/tk"
  spec.license       = "BSD-2-Clause"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions = ["ext/tk/extconf.rb", "ext/tk/tkutil/extconf.rb"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rake-compiler"

  spec.metadata["msys2_mingw_dependencies"] = "tk"
end
