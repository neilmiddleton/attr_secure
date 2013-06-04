module AttrSecure
  class Secure
    attr_reader   :env
    attr_accessor :object

    def initialize(env=ENV)
      @env = env
    end

    def encrypt(value, secret=nil)
      Fernet.generate(attr_secure_secret(secret)) do |generator|
        generator.data = { value: value }
      end
    end

    def decrypt(value, secret=nil)
      return nil if value.nil?
      verifier = Fernet.verifier(attr_secure_secret(secret), value)
      verifier.data['value'] if verifier.valid?
    end

    private

    def env!(key)
      env.fetch(key) { raise("Missing ENV(#{key})") }
    end

    def attr_secure_secret(secret)
      if secret.respond_to?(:call)
        secret.call(object)
      else
        secret || env!('ATTR_SECURE_SECRET')
      end
    end
  end
end
