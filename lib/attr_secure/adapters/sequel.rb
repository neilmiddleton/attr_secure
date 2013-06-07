module AttrSecure
  module Adapters
    module Sequel

      def self.valid?(object)
        object.respond_to?(:<) && defined?(Sequel) && object < ::Sequel::Model
      end

      def self.write_attribute(object, attribute, value)
        object[attribute.to_sym] = value
      end

      def self.read_attribute(object, attribute)
        object[attribute.to_sym]
      end
    end
  end
end

if defined?(Sequel)
  Sequel::Model.send(:extend, AttrSecure)
end
