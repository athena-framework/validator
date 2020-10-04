module Athena::Validator::Validatable
  # :nodoc:
  module Class; end

  macro included
    extend AVD::Validatable::Class

    class_getter validation_class_metadata : AVD::Metadata::ClassMetadata(self) { AVD::Metadata::ClassMetadata(self).build }
  end
end
