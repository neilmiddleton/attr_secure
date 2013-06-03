require 'spec_helper'

describe AttrSecure::Adapters::ActiveRecord do
  let(:described)   { Class.new(ActiveRecord::Base) }
  subject           { described.new }
  let(:secure_mock) { double(AttrSecure::Secure) }

  before do
    described.table_name = 'fake_database'
    described.extend(AttrSecure)
    described.attr_secure :title, secure_mock
  end

  it 'has ruby as it\'s adapter' do
    expect(described.attr_secure_adapter).to eq(AttrSecure::Adapters::ActiveRecord)
  end

  it 'encrypts' do
    secure_mock.should_receive(:encrypt).with('hello').and_return('encrypted')
    subject.title = 'hello'
    expect(subject.attributes['title']).to eq('encrypted')
  end

  it 'decrypts' do
    secure_mock.should_receive(:encrypt).with('hello').and_return('encrypted')
    subject.title = 'hello'
    secure_mock.should_receive(:decrypt).with('encrypted').and_return('decrypted')
    expect(subject.title).to eq('decrypted')
  end
end
