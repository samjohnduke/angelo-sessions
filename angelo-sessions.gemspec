# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'angelo/sessions/version'

Gem::Specification.new do |spec|
  spec.name          = "angelo-sessions"
  spec.version       = Angelo::Sessions::VERSION
  spec.authors       = ["Sam John Duke"]
  spec.email         = ["mail@samjohnduke.com"]
  spec.summary       = %q{Add sessions to an Angelo app}
  spec.description   = %q{Add sessions to an Angelo app}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "angelo"
end
