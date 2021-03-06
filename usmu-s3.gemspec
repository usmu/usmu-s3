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
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = Gem::Requirement.new('>= 2.0.0')

  spec.add_dependency 'usmu', '~> 1.0'
  spec.add_dependency 'logging', '~> 2.0'
  spec.add_dependency 'aws-sdk', '~> 2.0'
  #spec.add_dependency 'ruby-filemagic', '~> 0.6'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 11.0'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.2'
  spec.add_development_dependency 'yard', '~> 0.8'
  spec.add_development_dependency 'guard', '~> 2.8'
  spec.add_development_dependency 'guard-rspec', '~> 4.3'
  spec.add_development_dependency 'libnotify', '~> 0.9'
end
