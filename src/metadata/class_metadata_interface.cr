module Athena::Validator::Metadata::ClassMetadataInterface
  abstract def constrained_properties : Array(String)
  abstract def group_sequence : AVD::Constraints::GroupSequence?
  abstract def has_property_metadata?(name : String) : Bool
  abstract def property_metadata(name : String) : AVD::Metadata::PropertyMetadataInterfaceBase
end
