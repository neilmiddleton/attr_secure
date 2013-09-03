require 'spec_helper'

describe AttrSecure::Secure do
  subject      { described_class.new(secret) }
  let(:secret) { 'fWSvpC6Eh1/FFE1TUgXpcEzMmmGc9IZSqoexzEslzKI=' }

  describe 'encrypt' do
    it "should encrypt a string" do
      expect(subject.encrypt('encrypted')).to be_a(String)
      expect(subject.encrypt('encrypted')).to_not be_empty
      expect(subject.encrypt('encrypted')).to_not eq(subject.encrypt('encrypted'))
    end
  end

  describe 'decrypt' do
    let(:encrypted_value) { 'gAAAAABSJfL8uBP1f9hyMrqdaxqgMQdexzUtYMsu1s3ezUN2kH_Q0IfnxKGq6nC-AcGhSrSRDSHRz2kWU5E6_fmgwmNYsMrQlQ==' }

    it "should decrypt a string" do
      expect(subject.decrypt(encrypted_value)).to eq('decrypted')
    end
  end

  describe 'fernet 1.6 support' do
    describe 'encrypt' do
      it 'should encrypt a string' do
        expect(subject.old_encrypt('encrypted')).to be_a(String)
        expect(subject.old_encrypt('encrypted')).to_not be_empty
        expect(subject.old_encrypt('encrypted')).to_not eq(subject.old_encrypt('encrypted'))
      end
    end

    describe 'decrypt' do
      let(:encrypted_value) { subject.old_encrypt('decrypted') }

      it 'should decrypt a string' do
        expect(subject.old_decrypt(encrypted_value)).to eq('decrypted')
      end
    end
  end
end
