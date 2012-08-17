# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mach/version"

Gem::Specification.new do |s|
  s.name        = "mach"
  s.version     = Mach::VERSION
  s.authors     = ["Alan Skorkin"]
  s.email       = ["alan@skorks.com"]
  s.homepage    = "https://github.com/skorks/mach"
  s.summary     = %q{HMAC authentication stuff}
  s.description = %q{HMAC authentication stuff}

  s.rubyforge_project = "mach"

  s.add_dependency 'faraday'
  s.add_dependency 'rack'
  s.add_dependency 'multi_json'

  s.add_development_dependency  'rake'
  s.add_development_dependency  'rspec'
  s.add_development_dependency  'json'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
