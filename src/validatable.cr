module Athena::Validator::Validatable
  macro included
    class_getter validation_class_metadata : AVD::Metadata::ClassMetadata(self) { AVD::Metadata::ClassMetadata(self).build }
  end
end
