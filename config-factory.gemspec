# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'uri'
require 'config/factory/module_info'

Gem::Specification.new do |spec|
  spec.name          = Config::Factory::NAME
  spec.version       = Config::Factory::VERSION
  spec.authors       = ['David Moles']
  spec.email         = ['david.moles@ucop.edu']
  spec.summary       = 'A gem for creating configuration classes using the Abstract Factory pattern.'
  spec.description   = 'A gem for creating configuration classes using the Abstract Factory pattern, with run-time configuration provided by hashes or YAML files.'
  spec.license       = 'MIT'

  origin = `git config --get remote.origin.url`.chomp
  origin_uri = origin.start_with?('http') ? URI(origin) : URI(origin.sub('git@github.com:', 'https://github.com/'))
  spec.homepage = URI::HTTP.build(host: origin_uri.host, path: origin_uri.path.chomp('.git')).to_s

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }

  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'simplecov', '~> 0.9.2'
  spec.add_development_dependency 'simplecov-console', '~> 0.2.0'
  spec.add_development_dependency 'rubocop', '~> 0.35.1'
end
