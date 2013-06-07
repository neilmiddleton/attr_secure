module AttrSecure
  class Secret

    def initialize(options)
      @secret, @env = options.values_at(:secret, :env)
    end

    def call(object=nil)
      if secret.respond_to?(:call)
        secret.call(object)
      else
        secret || env!('ATTR_SECURE_SECRET')
      end
    end

    private
    attr_reader :secret, :env

    def env!(key)
      env.fetch(key) { raise("Missing ENV(#{key})") }
    end
  end
end
