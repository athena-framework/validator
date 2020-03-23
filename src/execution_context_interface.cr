module Athena::Validator::ExecutionContextInterface
  abstract def add_violation(message : String, parameters : Hash(String, String) = {} of String => String) : Nil
  abstract def build_violation(message : String, parameters : Hash(String, String) = {} of String => String) : AVD::Violation::ConstraintViolationBuilderInterface
  abstract def validator : AVD::Validator::ValidatorInterface
  abstract def object
  abstract def metadata : AVD::Metadata::MetadataInterface?
  abstract def property_name : String?
  abstract def group : String?
  abstract def root
  abstract def value
  # abstract def class_name
  # abstract def property_name : String
  abstract def property_path : String
  abstract def violations : AVD::Violation::ConstraintViolationListInterface

  # Internal

  # :nodoc:
  abstract def set_node(value : _, object : _, metadata : AVD::Metadata::MetadataInterface?, property_path : String) : Nil
  # :nodoc:
  abstract def group=(group : String)
  # :nodoc:
  abstract def constraint=(constraint : AVD::Constraint)
end
