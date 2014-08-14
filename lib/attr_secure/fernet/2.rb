Fernet::Configuration.run do |config|
  config.enforce_ttl = false
end

module AttrSecure
  module Fernet

    def encrypt(value)
      ::Fernet.generate([secret].flatten.first, value)
    end

    def decrypt(value)
      return nil if value.nil?

      [secret].flatten.each do |_secret|
        begin
          verifier = ::Fernet.verifier(_secret, value)
          return verifier.message if verifier.valid?
        rescue
        end
      end
      raise OpenSSL::Cipher::CipherError
    end
  end
end
