require 'spec_helper'

describe AttrSecure::Secure do
  context "with a simple key" do

    subject      { described_class.new(secret) }
    let(:secret) { 'fWSvpC6Eh1/FFE1TUgXpcEzMmmGc9IZSqoexzEslzKI=' }

    describe '#encrypt' do
      it "should encrypt a string" do
        expect(subject.encrypt('encrypted')).to be_a(String)
        expect(subject.encrypt('encrypted')).to_not be_empty
        expect(subject.encrypt('encrypted')).to_not eq(subject.encrypt('encrypted'))
      end
    end

    describe '#decrypt' do
      let(:encrypted_value) { subject.encrypt('decrypted') }

      it "should decrypt a string" do
        expect(subject.decrypt(encrypted_value)).to eq('decrypted')
      end
    end
  end

  # context "with an array of keys" do
  #   subject      { described_class.new(secret) }
  #   let(:secret) { 'fWSvpC6Eh1/FFE1TUgXpcEzMmmGc9IZSqoexzEslzKI=,d9ssNmUYn7UpMoSc0eM2glVUG2DPYwXveLTDU7j8pBY=' }

  #   describe '#encrypt' do
  #     it "should encrypt a string" do
  #       expect(subject.encrypt('encrypted')).to be_a(String)
  #       expect(subject.encrypt('encrypted')).to_not be_empty
  #       expect(subject.encrypt('encrypted')).to_not eq(subject.encrypt('encrypted'))
  #     end
  #   end

  #   describe '#decrypt' do
  #     let(:encrypted_value) { subject.encrypt('decrypted') }

  #     it "should decrypt a string" do
  #       expect(subject.decrypt(encrypted_value)).to eq('decrypted')
  #     end
  #   end
  # end
end
