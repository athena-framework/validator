module Athena::Validator::Metadata
  module PropertyMetadataInterfaceBase
    include Athena::Validator::Metadata::MetadataInterface

    abstract def name : String
  end

  module PropertyMetadataInterface(T)
    include Athena::Validator::Metadata::PropertyMetadataInterfaceBase
  end
end
