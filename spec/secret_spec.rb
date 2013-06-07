require 'spec_helper'

describe AttrSecure::Secret do
  let(:env)     { {'ATTR_SECURE_SECRET' => 'environment secret' } }
  let(:options) { {secret: secret, env: env} }
  subject       { described_class.new(options) }

  describe "with a nil secret" do
    let(:secret) { nil }

    it "should use the env variable" do
      expect(subject.call).to eq('environment secret')
    end
  end

  describe "with a string secret" do
    let(:secret) { 'string secret' }

    it "should use the string" do
      expect(subject.call).to eq('string secret')
    end
  end

  describe "with a lambda secret" do
    let(:secret) { lambda {|o| o } }

    it "should use the lambda" do
      expect(subject.call('lambda secret')).to eq('lambda secret')
    end
  end
end
