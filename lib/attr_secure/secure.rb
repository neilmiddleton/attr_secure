require 'fernet'

case Fernet::VERSION
  when /^2\.0/
    require 'attr_secure/fernet/2'
  when /^1\.6/
    require 'attr_secure/fernet/1'
  else
    raise "Invalid fernet version provided #{Fernet::VERSION}"
end

module AttrSecure
  class Secure
    include AttrSecure::Fernet
    attr_reader :secret

    def initialize(secret)
      self.secret = secret
    end

    def secret=(val)
      @secret = if val.is_a? Array
                  val
                else
                  val.split(",")
                end
    end
  end
end
