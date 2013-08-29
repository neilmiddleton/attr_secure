require 'fernet'

Fernet::Configuration.run do |config|
  config.enforce_ttl = false
end

module AttrSecure
  class Secure
    attr_reader :secret

    def initialize(secret)
      @secret = secret
    end

    def encrypt(value)
      Fernet.generate(secret, value)
    end

    def decrypt(value)
      return nil if value.nil?
      verifier = Fernet.verifier(secret, value)
      verifier.message if verifier.valid?
    end
  end
end
