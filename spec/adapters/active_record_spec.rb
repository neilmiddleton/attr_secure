require 'spec_helper'

describe AttrSecure::Adapters::ActiveRecord do
  let(:described) { Class.new(ActiveRecord::Base) }
  subject         { described.new }

  before do
    described.table_name = 'fake_database'
  end

  describe "valid?" do
    it "should be valid" do
      expect(described_class.valid?(described)).to be_true
    end

    it "should not be valid" do
      expect(described_class.valid?(String)).to be_false
    end

    it "should not be valid if activerecord is not loaded" do
      hide_const('ActiveRecord')
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
