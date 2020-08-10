require "../spec_helper"

private record Entity do
  include AVD::Validatable
end

describe AVD::Metadata::ClassMetadata do
  it "#add_property_constraint" do
    metadata = AVD::Metadata::ClassMetadata(Entity).new Entity
    metadata.add_property_constraint(
      AVD::Metadata::PropertyMetadata(String, Entity).new("name"),
      CustomConstraint.new ""
    )
    metadata.add_property_constraint(
      AVD::Metadata::PropertyMetadata(Int32, Entity).new("age"),
      CustomConstraint.new ""
    )

    metadata.constrained_properties.should eq ["name", "age"]
  end

  it "#has_property_metadata?" do
    metadata = AVD::Metadata::ClassMetadata(Entity).new Entity
    metadata.add_property_constraint(
      AVD::Metadata::PropertyMetadata(String, Entity).new("name"),
      CustomConstraint.new ""
    )

    metadata.has_property_metadata?("name").should be_true
    metadata.has_property_metadata?("age").should be_false
  end

  it "#property_metadata" do
    metadata = AVD::Metadata::ClassMetadata(Entity).new Entity

    name_metadata = AVD::Metadata::PropertyMetadata(String, Entity).new("name")

    metadata.add_property_constraint(name_metadata, CustomConstraint.new(""))

    metadata.property_metadata("name").should eq name_metadata
  end
end
