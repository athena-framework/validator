module Athena::Validator::ConstraintValidatorFactoryInterface
  # Returns the `AVD::ConstraintValidatorInterface` that should be used to validate the provided *constraint*.
  abstract def validator(constraint : AVD::Constraint) : AVD::ConstraintValidatorInterface
end
