# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'example/version'

Gem::Specification.new do |spec|
  spec.name        = "dataset"
  spec.version     = Example::VERSION
  spec.authors     = [ 'Sebastian Ziebell' ]
  spec.email       = [ 'sebastian.ziebell@asquera.de' ]
  spec.summary     = "Movies 100k dataset"
  spec.description = "Movies 100k dataset by MovieLens.org"
  spec.license     = %q{All rights reserved}
  spec.homepage    = ""

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "virtus", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
end
