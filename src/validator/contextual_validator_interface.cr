module Athena::Validator::Validator::ContextualValidatorInterface
  abstract def at_path(path : String) : AVD::Validator::ContextualValidatorInterface
  abstract def validate(value : _, constraints : Array(AVD::Constraint) | AVD::Constraint | Nil = nil, groups : Array(String) | String | Nil = nil) : AVD::Validator::ContextualValidatorInterface
  abstract def validate_property(object : AVD::Validatable, property_name : String, groups : Array(String) | String | Nil = nil) : AVD::Validator::ContextualValidatorInterface
  abstract def validate_property_value(object : AVD::Validatable, property_name : String, value : _, groups : Array(String) | String | Nil = nil) : AVD::Validator::ContextualValidatorInterface
  abstract def violations : AVD::Violation::ConstraintViolationListInterface
end
