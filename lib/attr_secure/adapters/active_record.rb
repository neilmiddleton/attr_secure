require 'attr_secure/secure'

module AttrSecure
  module Adapters
    module ActiveRecord

      def self.valid?(object)
        object.respond_to?(:<) && defined?(ActiveRecord) && object < ::ActiveRecord::Base
      end

      def self.write_attribute(object, attribute, value)
        object.send :write_attribute, attribute, value
      end

      def self.read_attribute(object, attribute)
        object.send :read_attribute, attribute.to_sym
      end
    end
  end
end

if defined?(ActiveRecord)
  ActiveRecord::Base.send(:extend, AttrSecure)
end
