require 'spec_helper'

describe AttrSecure::Secure do
  context "with a simple key" do

    subject       { described_class.new(secret1) }
    let(:secret1) { 'fWSvpC6Eh1/FFE1TUgXpcEzMmmGc9IZSqoexzEslzKI=' }
    let(:secret2) { 'd9ssNmUYn7UpMoSc0eM2glVUG2DPYwXveLTDU7j8pBY=' }

    describe '#secret=' do
      it "should update the list of secrets" do
        expect(subject.secret).to eq([secret1])
        subject.secret = secret2
        expect(subject.secret).to eq([secret2])
      end
    end

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

  [ ->(*secrets) { secrets.join(',') },
    ->(*secrets) { secrets } ].each do |make_secret|
    context "with an array of keys" do
      subject           { described_class.new(make_secret.call(secret1, secret2)) }
      let(:secret1)     { 'fWSvpC6Eh1/FFE1TUgXpcEzMmmGc9IZSqoexzEslzKI=' }
      let(:secret2)     { 'd9ssNmUYn7UpMoSc0eM2glVUG2DPYwXveLTDU7j8pBY=' }
      let(:key1_secure) { described_class.new(secret1) }
      let(:key2_secure) { described_class.new(secret2) }

      describe '#secret=' do
        it "should update the list of secrets" do
          expect(subject.secret).to eq([secret1, secret2])
          subject.secret = make_secret.call(secret2, secret1)
          expect(subject.secret).to eq([secret2, secret1])
        end
      end

      describe '#encrypt' do
        it "should encrypt a string" do
          expect(subject.encrypt('encrypted')).to be_a(String)
          expect(subject.encrypt('encrypted')).to_not be_empty
          expect(subject.encrypt('encrypted')).to_not eq(subject.encrypt('encrypted'))
        end

        it "should use the first secret to encrypt" do
          ciphertext = subject.encrypt('encrypted')
          expect(key1_secure.decrypt(ciphertext)).to eq("encrypted")
        end
      end

      describe '#decrypt' do
        let(:encrypted_value)     { subject.encrypt('decrypted') }
        let(:bare_value)          { "hello world" }
        let(:undecryptable_value) { other_encrypter.encrypt('decrypted') }

        it "should decrypt a string" do
          expect(subject.decrypt(encrypted_value)).to eq('decrypted')
        end

        it "should decrypt a string encrypted with any valid key" do
          key1_ciphertext = key1_secure.encrypt('encrypted')
          expect(subject.decrypt(key1_ciphertext)).to eq('encrypted')

          key2_ciphertext = key2_secure.encrypt('encrypted')
          expect(subject.decrypt(key2_ciphertext)).to eq('encrypted')
        end

        it "should raise if it cannot decrypt" do
          expect { subject.decrypt(undecryptable_value) }.to raise_error(StandardError)
        end
      end
    end
  end


end
