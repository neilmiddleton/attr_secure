require 'spec_helper'

describe AttrSecure::Secure do
  subject     { described_class.new({'ATTR_SECURE_SECRET' => token}) }
  let(:token) { 'fWSvpC6Eh1/FFE1TUgXpcEzMmmGc9IZSqoexzEslzKI=' }

  describe 'encrypt' do
    it "should encrypt a string" do
      expect(subject.encrypt('encrypted')).to be_a(String)
      expect(subject.encrypt('encrypted')).to_not be_empty
      expect(subject.encrypt('encrypted')).to_not eq(subject.encrypt('encrypted'))
    end

    it "should use the provided secret" do
      Fernet.should_receive(:generate).with('secret').and_return('generated')
      expect(subject.encrypt('encrypted', 'secret')).to eq('generated')
    end

    it "should use a lambda secret" do
      Fernet.should_receive(:generate).with('lambda secret').and_return('generated')
      expect(subject.encrypt('encrypted', lambda {|o| 'lambda secret' })).to eq('generated')
    end
  end

  describe 'decrypt' do
    let(:encrypted_value) { subject.encrypt('decrypted') }

    it "should decrypt a string" do
      expect(subject.decrypt(encrypted_value)).to eq('decrypted')
    end

    it "should decrypt a string with a provided secret" do
      secret = 'DQxyPfn6XQrPIlnK5rYuHjpPHJu04pQP6EVWSq/mIUw='
      value = subject.encrypt('my_encryption', secret)
      expect(subject.decrypt(value, secret)).to eq('my_encryption')
    end

    it "should decrypt a string with a lambda secret" do
      secret = 'DQxyPfn6XQrPIlnK5rYuHjpPHJu04pQP6EVWSq/mIUw='
      value = subject.encrypt('my_encryption', secret)
      expect(subject.decrypt(value, lambda {|o| secret })).to eq('my_encryption')
    end
  end
end
