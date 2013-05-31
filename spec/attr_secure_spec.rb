require 'spec_helper'

class FakeModelWithSecureAttributes
  extend AttrSecure
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


ENV['ATTR_SECURE_SECRET'] = 'xxx'

describe AttrSecure do
  subject { FakeModelWithSecureAttributes.new }

  it 'encrypts' do
    encrypter = lambda { |secret|
      assert_equal 'xxx', secret
      'world'
    }

    Fernet.stub :generate, encrypter do |f|
      subject.foo = 'hello'
      expect(subject.attributes[:foo]).to eq('world')
    end
  end

  it 'decrypts' do
    decrypter_mock = double(Object)
    decrypter_mock.stub(:valid?) { true }
    decrypter_mock.stub(:data) { {'value' => 'world'} }

    Fernet.stub(:generate, 'world') do
      Fernet.stub(:verifier, decrypter_mock) do
        subject.foo = 'hello'
        expect(subject.foo).to eq('world')
      end
    end
  end
end
