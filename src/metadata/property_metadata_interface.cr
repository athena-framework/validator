# Stores metadata associated with a specific property.
module Athena::Validator::Metadata::PropertyMetadataInterface
  include Athena::Validator::Metadata::MetadataInterface

  # Returns the name of the property represented via `self`.
  abstract def name : String
end
