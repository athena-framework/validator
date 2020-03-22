module Athena::Validator::ConstraintValidatorInterface
  abstract def context=(context : AVD::ExecutionContextInterface)
  protected abstract def validate(value : _, constraint : AVD::Constraint) : Nil
end
