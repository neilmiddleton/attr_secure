require "attr_secure/version"
require 'fernet'

require 'attr_secure/adapters/ruby'
require 'attr_secure/adapters/active_record'
require 'attr_secure/adapters/sequel'

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
    AttrSecure::Adapters::Sequel,
    AttrSecure::Adapters::Ruby
  ]

  # Generates attr_accessors that encrypt and decrypt attributes transparently
  def attr_secure(*attributes)
    options = {
      :encryption_class => Secure.new
    }.merge!(attributes.last.is_a?(Hash) ? attributes.pop : {})

    attribute = attributes.first

    define_method("#{attribute}=") do |value|
      if options[:secret]
        encrypted_value = options[:encryption_class].encrypt(value.nil? ? nil : value, options[:secret])
      else
        encrypted_value = options[:encryption_class].encrypt(value.nil? ? nil : value)
      end
      self.class.attr_secure_adapter.write_attribute self, attribute, encrypted_value
    end

    define_method("#{attribute}") do
      encrypted_value = self.class.attr_secure_adapter.read_attribute(self, attribute)
      if options[:secret]
        options[:encryption_class].decrypt encrypted_value, options[:secret]
      else
        options[:encryption_class].decrypt encrypted_value
      end
    end
  end

  def attr_secure_adapter
    ADAPTERS.find {|a| a.valid?(self) }
  end

end
