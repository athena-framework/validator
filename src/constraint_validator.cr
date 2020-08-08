require "./constraint_validator_interface"

abstract struct Athena::Validator::ConstraintValidator
  include Athena::Validator::ConstraintValidatorInterface

  property! context : AVD::ExecutionContextInterface

  def validate(value : _, constraint : AVD::Constraint) : Nil
    # Noop if a given validator doesn't support a given type of value
  end
end
