require 'fernet'

Fernet::Configuration.run do |config|
  config.enforce_ttl = false
end

module AttrSecure
  class Secure
    attr_reader :secret

    def initialize(secret)
      @secret = secret.split(",")
    end

    def secret=(val)
      @secret = val.split(",")
    end

    def encrypt(value)
      Fernet.generate([secret].flatten.first) do |generator|
        generator.data = { value: value }
      end
    end

    def decrypt(value)
      return nil if value.nil?
      [secret].flatten.each do |_secret|
        begin
          verifier = Fernet.verifier(_secret, value)
          return verifier.data['value'] if verifier.valid?
        rescue
        end
        raise OpenSSL::Cipher::CipherError
      end
    end

  end
end
