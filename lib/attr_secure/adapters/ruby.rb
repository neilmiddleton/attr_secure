module AttrSecure
  module Adapters
    module Ruby

      def self.valid?(object)
        true
      end

      def self.write_attribute(object, attribute, value)
        object.instance_variable_set "@#{attribute}", value
      end

      def self.read_attribute(object, attribute)
        object.instance_variable_get "@#{attribute}"
      end

    end
  end
end
