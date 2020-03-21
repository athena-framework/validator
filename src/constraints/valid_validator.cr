struct Athena::Validator::Constraints::ValidValidator < Athena::Validator::ConstraintValidator
  def validate(value : _, constraint : AVD::Constraints::NotBlank) : Nil
  end
end
