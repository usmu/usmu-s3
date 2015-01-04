# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'usmu/s3/version'

Gem::Specification.new do |spec|
  spec.name          = 'usmu-s3'
  spec.version       = Usmu::S3::VERSION
  spec.authors       = ['Matthew Scharley']
  spec.email         = ['matt.scharley@gmail.com']
  spec.summary       = %q{S3 publishing plugin for Usmu.}
  spec.homepage      = 'https://github.com/usmu/usmu-s3'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'usmu', '~> 0.3'
  spec.add_dependency 'aws-sdk', '~> 2.0.pre'
  spec.add_dependency 'logging', '~> 1.8'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'yard', '~> 0.8'
  spec.add_development_dependency 'cane', '~> 2.6'
  spec.add_development_dependency 'simplecov', '~> 0.9'
  spec.add_development_dependency 'guard', '~> 2.8'
  spec.add_development_dependency 'guard-rspec', '~> 4.3'
  spec.add_development_dependency 'libnotify', '~> 0.9'
  spec.add_development_dependency 'turnip', '~> 1.2'
end
