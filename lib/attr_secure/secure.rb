module AttrSecure
  class Secure
    attr_reader :env

    def initialize(env=ENV)
      @env = env
    end

    def encrypt(value)
      Fernet.generate(attr_secure_secret) do |generator|
        generator.data = { value: value }
      end
    end

    def decrypt(value)
      return nil if value.nil?
      verifier = Fernet.verifier(attr_secure_secret, value)
      verifier.data['value'] if verifier.valid?
    end

    private
    def env!(key)
      env.fetch(key) { raise("Missing ENV(#{key})") }
    end

    def attr_secure_secret
      env!('ATTR_SECURE_SECRET')
    end
  end
end
