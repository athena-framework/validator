module Athena::Validator::ConstraintValidatorFactoryInterface
  # Returns an `AVD::ConstraintValidatorInterface` instance based on the provided *validator_class*.
  abstract def validator(validator : AVD::ConstraintValidator.class) : AVD::ConstraintValidator
end
