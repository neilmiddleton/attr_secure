module AttrSecure
  class Secure

    def encrypt(value)
      Fernet.generate(attr_secure_secret) do |generator|
        generator.message = value
      end
    end

    def decrypt(value)
      return nil if value.nil?
      verifier = Fernet.verifier(attr_secure_secret, value)
      verifier.message if verifier.valid?
    end

    private
    def env!(key)
      ENV.fetch(key) { raise("Missing ENV(#{key})") }
    end

    def attr_secure_secret
      env!('ATTR_SECURE_SECRET')
    end
  end
end
