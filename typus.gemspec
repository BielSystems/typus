# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'typus/version'

files = `git ls-files`.split($/)
test_files = `git ls-files -- test/*`.split($/)
ignores = `git ls-files -- doc/* .travis.yml .gitignore`.split($/)

Gem::Specification.new do |spec|
  spec.name          = "typus"
  spec.version       = Typus::VERSION::STRING
  spec.authors       = ["Francesc Esplugas"]
  spec.email         = ["support@typuscmf.com"]
  spec.description   = "Ruby on Rails Admin Panel (Engine) to allow trusted users edit structured content."
  spec.summary       = "Effortless backend interface for Ruby on Rails applications. (Admin scaffold generator)"
  spec.homepage      = "http://www.typuscmf.com/"
  spec.license       = "MIT"

  spec.platform = Gem::Platform::RUBY

  spec.files         = files - test_files - ignores
  spec.test_files    = []
  spec.require_paths = ["lib"]

  spec.add_dependency "bcrypt-ruby", "~> 3.1.5"
  spec.add_dependency "jquery-rails"
  spec.add_dependency "rails", "~> 4.0.0"
end
