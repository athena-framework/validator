module Athena::Validator::Violation::ConstraintViolationBuilderInterface
  abstract def at_path(path : String) : AVD::Violation::ConstraintViolationBuilderInterface
  abstract def add_parameter(key : String, value : String) : AVD::Violation::ConstraintViolationBuilderInterface
  abstract def set_parameters(parameters : Hash(String, String)) : AVD::Violation::ConstraintViolationBuilderInterface
  abstract def invalid_value(value : _) : AVD::Violation::ConstraintViolationBuilderInterface
  abstract def plural(number : Int32) : AVD::Violation::ConstraintViolationBuilderInterface
  abstract def code(code : String?) : AVD::Violation::ConstraintViolationBuilderInterface
  abstract def cause(code : String?) : AVD::Violation::ConstraintViolationBuilderInterface
  abstract def add : Nil
end
