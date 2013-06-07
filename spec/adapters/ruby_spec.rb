require 'spec_helper'

describe AttrSecure::Adapters::Ruby do
  subject { Class.new }

  describe "valid?" do
    it "should be valid all the time" do
      expect(described_class.valid?(String)).to be_true
    end
  end

  describe "write attribute" do
    it "should set the instance variable" do
      described_class.write_attribute(subject, 'secure', 'hello')
      expect(subject.instance_variable_get("@secure")).to eql('hello')
    end
  end

  describe "read attribute" do
    it "should read an instance variable" do
      subject.instance_variable_set("@secure", 'world')
      expect(described_class.read_attribute(subject, 'secure')).to eq('world')
    end
  end
end
