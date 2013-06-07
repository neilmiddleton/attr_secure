require 'spec_helper'

describe AttrSecure do
  describe "reading and writing attributes" do
    subject           { described.new }
    let(:described)   { Class.new }
    let(:secure_mock) { double(AttrSecure::Secure) }
    let(:secret_mock) { double(AttrSecure::Secret) }
    let(:crypter)     { mock(:secure_crypter) }
    let(:adapter)     { mock(:adapter) }

    before do
      described.extend(AttrSecure)
      described.attr_secure :foo,
        encryption_class: secure_mock,
        secret_class:     secret_mock

      secret_mock.stub_chain(:new, :call).and_return('secret token')
      secure_mock.should_receive(:new).with('secret token').and_return(crypter)
      described.stub(:attr_secure_adapter).and_return(adapter)
    end

    describe "set the attribute" do
      it "should set the attribute encrypted" do
        crypter.should_receive(:encrypt).with('decrypted').and_return('encrypted')
        adapter.should_receive(:write_attribute).with(subject, :foo, 'encrypted')
        subject.foo = 'decrypted'
      end
    end

    describe "read the attribute" do
      it "should read an encrypted attribute" do
        adapter.should_receive(:read_attribute).with(subject, :foo).and_return('encrypted')
        crypter.should_receive(:decrypt).with('encrypted').and_return('decrypted')
        expect(subject.foo).to eq('decrypted')
      end
    end
  end

  describe "retrieving the adapter" do
    describe "ruby" do
      subject { Class.new }

      before do
        subject.extend(AttrSecure)
      end

      it "should get the adapter" do
        expect(subject.attr_secure_adapter).to eq(AttrSecure::Adapters::Ruby)
      end
    end

    describe "active record" do
      subject { Class.new(ActiveRecord::Base) }

      before do
        subject.extend(AttrSecure)
      end

      it "should get the adapter" do
        expect(subject.attr_secure_adapter).to eq(AttrSecure::Adapters::ActiveRecord)
      end
    end

    describe "ruby" do
      subject { Class.new(Sequel::Model) }

      before do
        subject.extend(AttrSecure)
      end

      it "should get the adapter" do
        expect(subject.attr_secure_adapter).to eq(AttrSecure::Adapters::Sequel)
      end
    end
  end
end
