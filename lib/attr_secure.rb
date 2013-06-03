require "attr_secure/version"
require 'fernet'

require 'attr_secure/adapters/ruby'
require 'attr_secure/adapters/active_record'

Fernet::Configuration.run do |config|
  config.enforce_ttl = false
end

module AttrSecure
  #
  # All the available adapters.
  # The order in this list matters, as only the first valid adapter will be used
  #
  ADAPTERS = [
    AttrSecure::Adapters::ActiveRecord,
    AttrSecure::Adapters::Ruby
  ]

  def attr_secure(attribute, encryption_class = Secure.new)
    define_method("#{attribute}=") do |value|
      encrypted_value = encryption_class.encrypt(value.nil? ? nil : value)
      self.class.attr_secure_adapter.write_attribute self, attribute, encrypted_value
    end

    define_method("#{attribute}") do
      encrypted_value = self.class.attr_secure_adapter.read_attribute(self, attribute)
      encryption_class.decrypt encrypted_value
    end
  end

  def attr_secure_adapter
    ADAPTERS.find {|a| a.valid?(self) }
  end
end
