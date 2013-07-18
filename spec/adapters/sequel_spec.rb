require 'spec_helper'

describe AttrSecure::Adapters::Sequel do
  let(:described) { Class.new(Sequel::Model) }
  subject         { described.new }

  before do
    described.set_dataset(:fake_database)
  end

  describe "valid?" do
    it "should be valid" do
      expect(described_class.valid?(described)).to be_true
    end

    it "should not be valid" do
      expect(described_class.valid?(String)).to be_false
    end

    it "should not be valid if sequel is not loaded" do
      hide_const('Sequel')
      expect(described_class.valid?(described)).to be_false
    end
  end

  describe "write attribute" do
    it "should write an attribute" do
      described_class.write_attribute(subject, 'title', 'hello')
      expect(subject.title).to eq('hello')
    end
  end

  describe "read attribute" do
    it "should read an instance variable" do
      subject.title = 'world'
      expect(described_class.read_attribute(subject, 'title')).to eq('world')
    end
  end
end
