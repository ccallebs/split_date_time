# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'split_date_time/version'

Gem::Specification.new do |spec|
  spec.name          = "split_date_time"
  spec.version       = SplitDateTime::VERSION
  spec.authors       = ["Chuck Callebs"]
  spec.email         = ["cacallebs@gmail.com"]
  spec.description   = %q{Allows DateTime fields to be split into a Date field and a Time field.}
  spec.summary       = %q{Allows DateTime fields to be split into a Date field and a Time field.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
