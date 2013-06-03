require 'spec_helper'

describe AttrSecure::Adapters::Sequel do
  let(:described)   { Class.new(Sequel::Model) }
  subject           { described.new }
  let(:secure_mock) { double(AttrSecure::Secure) }

  before do
    described.set_dataset(:fake_database)
    described.extend(AttrSecure)
    described.attr_secure :title, secure_mock
    raise described.inspect
  end

  it 'has sequel as it\'s adapter' do
    expect(described.attr_secure_adapter).to eq(AttrSecure::Adapters::Sequel)
  end

  it 'encrypts' do
    secure_mock.should_receive(:encrypt).with('hello').and_return('encrypted')
    subject.title = 'hello'
    expect(subject.values[:title]).to eq('encrypted')
  end

  it 'decrypts' do
    secure_mock.should_receive(:encrypt).with('hello').and_return('encrypted')
    subject.title = 'hello'
    secure_mock.should_receive(:decrypt).with('encrypted').and_return('decrypted')
    expect(subject.title).to eq('decrypted')
  end
end
