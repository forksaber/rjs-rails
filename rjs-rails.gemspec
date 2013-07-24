$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rjs-rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rjs-rails"
  s.version     = RjsRails::VERSION
  s.authors     = ["neeraj"]
  s.summary     = "requirejs support for rails"
  s.description = "requires support for rail"

  s.files = Dir["{app,config,db,lib,tasks,vendor}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.11"

  s.add_development_dependency "sqlite3"
end
