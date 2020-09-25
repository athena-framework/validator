module Athena::Validator::Metadata::PropertyMetadataInterfaceBase
  include Athena::Validator::Metadata::MetadataInterface

  abstract def name : String
end
