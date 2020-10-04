require "./constraint_validator_factory_interface"

struct Athena::Validator::ConstraintValidatorFactory
  include Athena::Validator::ConstraintValidatorFactoryInterface

  @validators : Hash(AVD::ConstraintValidator.class, AVD::ConstraintValidator) = Hash(AVD::ConstraintValidator.class, AVD::ConstraintValidator).new

  def validator(validator_class : AVD::ConstraintValidator.class) : AVD::ConstraintValidator
    if validator = @validators[validator_class]?
      return validator
    end

    @validators[validator_class] = validator_class.new
  end
end
