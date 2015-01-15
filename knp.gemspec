$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "knp/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "knp"
  s.version     = Knp::VERSION
  s.authors     = ['Killbill core team']
  s.email       = ['killbilling-users@googlegroups.com']
  s.homepage    = 'http://killbill.io'
  s.summary     = 'Kill Bill Notifications Proxy'
  s.description = 'Externally-facing proxy to forward notifications to Kill Bill'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.add_dependency "rails", "~> 3.2.0"
  s.add_dependency "killbill-client", "~> 0.10.2"

  s.add_development_dependency "sqlite3"
end
