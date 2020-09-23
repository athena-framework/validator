module Athena::Validator::Validator::ValidatorInterface
  abstract def validate(value : _, constraints : Array(AVD::Constraint) | AVD::Constraint | Nil = nil, groups : Array(String) | String | Nil = nil) : AVD::Violation::ConstraintViolationListInterface
  abstract def validate_property(object : AVD::Validatable, property_name : String, groups : Array(String) | String | Nil = nil) : AVD::Violation::ConstraintViolationListInterface
  abstract def validate_property_value(object : AVD::Validatable, property_name : String, value : _, groups : Array(String) | String | Nil = nil) : AVD::Violation::ConstraintViolationListInterface

  abstract def start_context : AVD::Validator::ContextualValidatorInterface
  abstract def in_context(context : AVD::ExecutionContextInterface) : AVD::Validator::ContextualValidatorInterface
end
