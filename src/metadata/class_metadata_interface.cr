module Athena::Validator::Metadata::ClassMetadataInterface
  abstract def constrained_properties : Array(String)
  abstract def has_property_metadata(name : String) : Bool
  abstract def property_metadata(name : String)
  abstract def class_name : String
end
