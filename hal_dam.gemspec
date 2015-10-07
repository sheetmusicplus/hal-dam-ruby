# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hal_dam/version'

Gem::Specification.new do |spec|
  spec.name          = 'hal_dam'
  spec.version       = HalDam::VERSION
  spec.authors       = ['Tanner Donovan']
  spec.email         = ['tdonovan@sheetmusicplus.com']

  spec.summary       = 'Client library for the Hal Leonard DAM System'
  spec.homepage      = 'https://github.com/sheetmusicplus/hal-dam-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'builder', '~> 3.2'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake','~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
end
