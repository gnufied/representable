# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'representable/version'

Gem::Specification.new do |s|
  s.name        = "representable"
  s.version     = Representable::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nick Sutterer"]
  s.email       = ["apotonick@gmail.com"]
  s.homepage    = "http://representable.apotomo.de"
  s.summary     = %q{Maps representation documents from and to Ruby objects. Includes XML and JSON support, plain properties and compositions.}
  s.description = %q{Maps representation documents from and to Ruby objects. Includes XML and JSON support, plain properties and compositions.}
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency "activesupport"

  s.add_dependency "hooks"
  s.add_dependency "nokogiri"
  s.add_dependency "i18n"
  s.add_dependency "json"
  
  s.add_development_dependency "rspec"
  s.add_development_dependency "test_xml"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "activerecord", "~> 3.0.7"
end
