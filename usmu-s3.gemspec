# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'usmu/s3/version'

Gem::Specification.new do |spec|
  spec.name          = 'usmu-s3'
  spec.version       = Usmu::S3::VERSION
  spec.authors       = ['Matthew Scharley']
  spec.email         = ['matt.scharley@gmail.com']
  spec.summary       = %q{A static site generator with a web-based frontend for editing.}
  spec.homepage      = 'https://github.com/usmu/usmu-s3'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'usmu'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'cucumber', '~> 1.3'
  spec.add_development_dependency 'yard', '~> 0.8'
  spec.add_development_dependency 'cane', '~> 2.6'
end
