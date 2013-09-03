require 'old_fernet/version'
require 'old_fernet/generator'
require 'old_fernet/verifier'
require 'old_fernet/secret'
require 'old_fernet/configuration'

if RUBY_VERSION == '1.8.7'
  require 'shim/base64'
end

OldFernet::Configuration.run

module OldFernet
  def self.generate(secret, encrypt = Configuration.encrypt, &block)
    Generator.new(secret, encrypt).generate(&block)
  end

  def self.verify(secret, token, encrypt = Configuration.encrypt, &block)
    Verifier.new(secret, encrypt).verify_token(token, &block)
  end

  def self.verifier(secret, token, encrypt = Configuration.encrypt)
    Verifier.new(secret, encrypt).tap do |v|
      v.verify_token(token)
    end
  end
end
