require "attr_secure/version"
require 'attr_secure/secure'
require 'attr_secure/secret'

require 'attr_secure/adapters/ruby'
require 'attr_secure/adapters/active_record'
require 'attr_secure/adapters/sequel'

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
      :encryption_class => Secure,
      :secret_class     => Secret,
      :env              => ENV
    }.merge!(attributes.last.is_a?(Hash) ? attributes.pop : {})

    attribute = attributes.first

    define_method("#{attribute}=") do |value|
      adapter = self.class.attr_secure_adapter
      secret  = options[:secret_class].new(options).call(self)
      crypter = options[:encryption_class].new(secret)
      value   = crypter.encrypt(value)

      adapter.write_attribute self, attribute, value
    end

    define_method("#{attribute}") do
      adapter = self.class.attr_secure_adapter
      secret  = options[:secret_class].new(options).call(self)
      crypter = options[:encryption_class].new(secret)
      value   = adapter.read_attribute(self, attribute)

      crypter.decrypt value
    end
  end

  def attr_secure_adapter
    ADAPTERS.find {|a| a.valid?(self) }
  end

end
