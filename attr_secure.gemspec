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

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "sequel"
  spec.add_development_dependency "sqlite3"

  spec.add_dependency 'fernet', '~> 2.0.rc1'

  # Support for fernet 1.6 migration
  spec.add_dependency "yajl-ruby"
  spec.add_dependency "multi_json"

  spec.post_install_message = "If you're upgrading attr_secure from 0.2.1 or below, the encryption method provided by Fernet has changed.
  You need to migrate your encrypted data to the new system.
  See more in our README: https://github.com/neilmiddleton/attr_secure#migration-to-fernet-20"
end
