require 'spec_helper'

describe AttrSecure do
  describe "reading and writing attributes" do
    subject           { described.new }
    let(:described)   { Class.new }
    let(:secure_mock) { double(AttrSecure::Secure) }
    let(:secret_mock) { double(AttrSecure::Secret) }
    let(:crypter)     { double(:secure_crypter) }
    let(:adapter)     { double(:adapter) }

    before do
      described.extend(AttrSecure)
      described.attr_secure :foo,
        encryption_class: secure_mock,
        secret_class:     secret_mock

      secret_mock.stub_chain(:new, :call).and_return('secret token')
      described.stub(:attr_secure_adapter).and_return(adapter)
    end

    describe "set the attribute" do
      it "should set the attribute encrypted" do
        secure_mock.should_receive(:new).with('secret token').and_return(crypter)
        crypter.should_receive(:encrypt).with('decrypted').and_return('encrypted')
        adapter.should_receive(:write_attribute).with(subject, :foo, 'encrypted')
        subject.foo = 'decrypted'
      end

      it "should set nil attributes as nil" do
        crypter.should_not_receive(:encrypt).with(nil)
        adapter.should_receive(:write_attribute).with(subject, :foo, nil)
        subject.foo = nil
      end

      it "should set empty attributes as empty" do
        crypter.should_not_receive(:encrypt).with('')
        adapter.should_receive(:write_attribute).with(subject, :foo, '')
        subject.foo = ''
      end
    end

    describe "read the attribute" do
      it "should read an encrypted attribute" do
        secure_mock.should_receive(:new).with('secret token').and_return(crypter)
        adapter.should_receive(:read_attribute).with(subject, :foo).and_return('encrypted')
        crypter.should_receive(:decrypt).with('encrypted').and_return('decrypted')
        expect(subject.foo).to eq('decrypted')
      end

      it "should read nil attributes as nil" do
        adapter.should_receive(:read_attribute).with(subject, :foo).and_return(nil)
        crypter.should_not_receive(:decrypt).with(nil)
        expect(subject.foo).to be_nil
      end

      it "should set empty attributes as empty" do
        adapter.should_receive(:read_attribute).with(subject, :foo).and_return('')
        crypter.should_not_receive(:decrypt).with('')
        expect(subject.foo).to be_empty
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
