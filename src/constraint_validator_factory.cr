require "./constraint_validator_factory_interface"

struct Athena::Validator::ConstraintValidatorFactory
  include Athena::Validator::ConstraintValidatorFactoryInterface

  @validators : Hash(AVD::ConstraintValidator.class, AVD::ConstraintValidator) = Hash(AVD::ConstraintValidator.class, AVD::ConstraintValidator).new

  # :inherit:
  def validator(constraint : AVD::Constraint) : AVD::ConstraintValidatorInterface
    validator_class = constraint.class.validator

    @validators[validator_class] = validator_class.new unless @validators.has_key? validator_class

    @validators[validator_class]
  end
end
