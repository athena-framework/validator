module Athena::Validator::Validator::ContextualValidatorInterface
  abstract def at_path(path : String) : AVD::Validator::ContextualValidatorInterface
  abstract def validate(value : _, constraints : Array(Constraint)? = nil, groups : Array(String)? = nil) : AVD::Validator::ContextualValidatorInterface
  abstract def validate_property(object : AVD::Validatable, property_name : String, groups : Array(String)? = nil) : AVD::Validator::ContextualValidatorInterface
  abstract def validate_property_value(object : AVD::Validatable, property_name : String, value : _, groups : Array(String)? = nil) : AVD::Validator::ContextualValidatorInterface
  abstract def violations : AVD::Violation::ConstraintViolationListInterface
end
