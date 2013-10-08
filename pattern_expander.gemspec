# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pattern_expander/version'

Gem::Specification.new do |spec|
  spec.name          = "pattern_expander"
  spec.version       = PatternExpander::VERSION
  spec.authors       = ["Noah Thorp"]
  spec.email         = ["noah@rixiform.com"]
  spec.description   = %q{Generate string pattern combinations}
  spec.summary       = %q{Expands strings of patterns into indexes of combinations (kinda like a reverse regex). }
  spec.homepage      = "http://www.github.com/aquabu/pattern_expander"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
