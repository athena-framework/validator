abstract struct Athena::Validator::ConstraintValidator
  include Athena::Validator::ConstraintValidatorInterface

  property! context : AVD::ExecutionContextInterface

  def validate(value : _, constraint : AVD::Constraint) : Nil
  end
end
