module Athena::Validator::Validatable
  macro included
    extend AVD::Validatable

    def validation_metadata_class : AVD::Metadata::ClassMetadata.class
      AVD::Metadata::ClassMetadata({{@type}})
    end
  end
end
