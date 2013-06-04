require 'spec_helper'

describe AttrSecure::Adapters::Ruby do

  let(:described)   { Class.new }
  subject           { described.new }
  let(:secure_mock) { double(AttrSecure::Secure) }

  before do
    described.extend(AttrSecure)
    described.attr_secure :foo, :encryption_class => secure_mock
  end

  it 'has ruby as it\'s adapter' do
    expect(described.attr_secure_adapter).to eq(AttrSecure::Adapters::Ruby)
  end

  it 'encrypts' do
    secure_mock.should_receive(:encrypt).with('hello').and_return('encrypted')
    subject.foo = 'hello'
    expect(subject.instance_variable_get(:@foo)).to eq('encrypted')
  end

  it 'decrypts' do
    secure_mock.should_receive(:encrypt).with('hello').and_return('encrypted')
    subject.foo = 'hello'
    secure_mock.should_receive(:decrypt).with('encrypted').and_return('decrypted')
    expect(subject.foo).to eq('decrypted')
  end

  context 'with explicit secret' do
    before do
      described.extend(AttrSecure)
      described.attr_secure :foo, :secret => 'sekrit', :encryption_class => secure_mock
    end

    it 'uses the defined secret' do
      secure_mock.should_receive(:encrypt).with('hello', 'sekrit').and_return('encrypted')
      subject.foo = 'hello'
      secure_mock.should_receive(:decrypt).with('encrypted', 'sekrit').and_return('decrypted')
      expect(subject.foo).to eq('decrypted')
    end
  end
end
