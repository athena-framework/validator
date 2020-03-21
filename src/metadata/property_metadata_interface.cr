module Athena::Validator::Metadata
  module PropertyMetadataInterfaceBase
    include Athena::Validator::Metadata::MetadataInterface

    abstract def name : String
    abstract def value
  end

  module PropertyMetadataInterface(T)
    include Athena::Validator::Metadata::PropertyMetadataInterfaceBase

    abstract def value : T
  end
end
