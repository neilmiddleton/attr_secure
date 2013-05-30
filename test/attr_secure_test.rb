require 'minitest/autorun'
require 'minitest/mock'
require 'attr_secure'

class FakeModelWithSecureAttributes
  include AttrSecure
  attr_accessor :attributes

  attr_secure :foo

  def initialize(attributes={})
    @attributes = attributes
  end

  def read_attribute(attr_name)
    attributes[attr_name]
  end

  def write_attribute(attr_name, value)
    attributes[attr_name] = value
  end
end

class TestAttrSecure < MiniTest::Unit::TestCase
  def setup
    @subject = FakeModelWithSecureAttributes.new
    ENV['ATTR_SECURE_SECRET'] = 'xxx'
  end

  def test_encrypt
    encrypter = lambda { |secret|
      assert_equal 'xxx', secret
      'world'
    }

    Fernet.stub :generate, encrypter do |f|
      @subject.foo = 'hello'
      assert_equal 'world', @subject.attributes[:foo]
    end
  end

  def test_decrypt
    decrypter_mock = MiniTest::Mock.new
    decrypter_mock.expect(:valid?, true)
    decrypter_mock.expect(:data, {'value' => 'world'})

    Fernet.stub(:generate, 'world') do
      Fernet.stub(:verifier, decrypter_mock) do
        @subject.foo = 'hello'
        assert_equal 'world', @subject.foo
      end
    end

    decrypter_mock.verify
  end
end
