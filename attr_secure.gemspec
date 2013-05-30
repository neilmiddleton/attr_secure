# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'attr_secure/version'

Gem::Specification.new do |spec|
  spec.name          = "attr_secure"
  spec.version       = AttrSecure::VERSION
  spec.authors       = ["Neil Middleton"]
  spec.email         = ["neil@neilmiddleton.com"]
  spec.description   = %q{Securely stores activerecord model attributes}
  spec.summary       = %q{Securely stores activerecord model attributes}
  spec.homepage      = "http://www.neilmiddleton.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency 'fernet'
  spec.add_dependency 'activesupport', ' ~> 3.2.0'
end
