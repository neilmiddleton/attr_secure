require "attr_secure/version"
require 'fernet'
require 'active_record'

require 'attr_secure/secure'

Fernet::Configuration.run do |config|
  config.enforce_ttl = false
end

module AttrSecure

  def attr_secure(attribute)
    define_method("#{attribute}=") do |value|
      write_attribute(attribute, Secure.new.encrypt(value.nil? ? nil : value.to_sym))
    end

    define_method("#{attribute}") do
      Secure.new.decrypt read_attribute(attribute.to_sym)
    end
  end
end

ActiveRecord::Base.send(:extend, AttrSecure)
