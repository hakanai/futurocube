# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'futurocube/version'

Gem::Specification.new do |spec|
  spec.name          = 'futurocube'
  spec.version       = FuturoCube::VERSION
  spec.authors       = ['Trejkaz']
  spec.email         = ['trejkaz@trypticon.org']
  spec.description   = %q{Tools for messing with FuturoCube data}
  spec.summary       = %q{Contains tools and parsers for messing with data for the Rubik's FuturoCube.}
  spec.homepage      = 'https://github.com/trejkaz/futurocube'
  spec.license       = 'MIT'

  spec.files         = [ "COPYING.txt", "Gemfile", "Gemfile.lock", "README.md",
                         "Rakefile", "#{spec.name}.gemspec" ] +
                       Dir.glob("bin/*") +
                       Dir.glob("lib/**/*.rb")

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'

  spec.add_runtime_dependency 'bindata'
  spec.add_runtime_dependency 'wavefile'
  spec.add_runtime_dependency 'progressbar'
end
