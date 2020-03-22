require "./generic_metadata"
require "./class_metadata_interface"

struct Athena::Validator::Metadata::ClassMetadata
  include Athena::Validator::Metadata::GenericMetadata
  include Athena::Validator::Metadata::ClassMetadataInterface

  getter default_group : String
  @cascading_strategy : AVD::Metadata::CascadingStrategy = AVD::Metadata::CascadingStrategy::None

  @properties : Hash(String, AVD::Metadata::PropertyMetadataInterfaceBase) = Hash(String, AVD::Metadata::PropertyMetadataInterfaceBase).new

  def initialize(@class : Validatable)
    @default_group = @class.to_s
  end

  def add_constraint(constraint : AVD::Constraint) : AVD::Metadata::ClassMetadata
    constraint.add_implicit_group @default_group

    super constraint

    return self
  end

  def add_property_constraint(property_metadata : AVD::Metadata::PropertyMetadataInterfaceBase, constraint : AVD::Constraint) : AVD::Metadata::ClassMetadata
    unless @properties.has_key? property_metadata.name
      @properties[property_metadata.name] = property_metadata
    end

    constraint.add_implicit_group @default_group

    @properties[property_metadata.name].add_constraint constraint

    self
  end

  def constrained_properties : Array(String)
    @properties.keys
  end

  def has_property_metadata(property_name : String) : Bool
  end

  def property_metadata(property_name : String)
    @properties[property_name]
  end

  def class_name : String
  end
end
