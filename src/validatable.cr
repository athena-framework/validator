module Athena::Validator::Validatable
  macro included
    extend AVD::Validatable

    # :nodoc:
    class_getter validation_class_metadata : AVD::Metadata::ClassMetadata({{@type}}) { AVD::Metadata::ClassMetadata({{@type}}).build }
  end
end
