require "attr_secure/version"
require 'fernet'
require 'active_record'

Fernet::Configuration.run do |config|
  config.enforce_ttl = false
end

module AttrSecure
  extend ActiveSupport::Concern

  def env!(key)
    ENV[key] || raise("Missing ENV(#{key})")
  end

  def encrypt(value)
    Fernet.generate(env!('ATTR_SECURE_SECRET')) do |generator|
      generator.data = { value: value }
    end
  end

  def decrypt(value)
    return nil if value.nil?
    verifier = Fernet.verifier(env!('ATTR_SECURE_SECRET'), value)
    verifier.data["value"] if verifier.valid?
  end

  module ClassMethods

    def attr_secure(attribute)
      define_method("#{attribute}=") do |value|
        write_attribute(attribute, encrypt(value.nil? ? nil : value.to_sym))
      end

      define_method("#{attribute}") do
        decrypt read_attribute(attribute.to_sym)
      end
    end

  end
end

ActiveRecord::Base.send(:include, AttrSecure)
