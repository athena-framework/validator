require "./spec_helper"

private class ManualConstraints
  include AVD::Validatable

  def self.load_metadata(class_metadata : AVD::Metadata::ClassMetadata) : Nil
    class_metadata.add_property_constraint "name", AVD::Constraints::EqualTo.new("foo")
  end

  def initialize(@name : String); end
end

describe AVD::Validatable do
  describe ".load_metadata" do
    it "should manually add constraints to the metadata object" do
      ManualConstraints.validation_class_metadata.constrained_properties.should eq ["name"]
    end
  end
end
