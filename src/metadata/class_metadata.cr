require "./generic_metadata"
require "./class_metadata_interface"

struct Athena::Validator::Metadata::ClassMetadata
  include Athena::Validator::Metadata::GenericMetadata
  include Athena::Validator::Metadata::ClassMetadataInterface

  getter default_group : String
  # getter class_name : AVD::Validatable

  @cascading_strategy : AVD::Metadata::CascadingStrategy = AVD::Metadata::CascadingStrategy::None
  @properties : Hash(String, AVD::Metadata::PropertyMetadataInterfaceBase) = Hash(String, AVD::Metadata::PropertyMetadataInterfaceBase).new

  def initialize(class_name)
    @default_group = @class_name.to_s
  end

  def add_constraint(constraint : AVD::Constraint) : AVD::Metadata::ClassMetadata
    constraint.add_implicit_group @default_group

    super constraint

    self
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
    @properties.has_key? property_name
  end

  def property_metadata(property_name : String) : AVD::Metadata::PropertyMetadataInterfaceBase
    @properties[property_name]
  end

  def name : String?
    nil
  end
end
