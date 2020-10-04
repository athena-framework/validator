module Athena::Validator::Metadata::MetadataFactoryInterface
  abstract def metadata(object) : AVD::Metadata::ClassMetadata
end
