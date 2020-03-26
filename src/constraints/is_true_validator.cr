struct Athena::Validator::Constraints::IsTrueValidator < Athena::Validator::ConstraintValidator
  # :inherit:
  def validate(value : _, constraint : AVD::Constraints::IsTrue) : Nil
    return if value.nil? || value

    self.context
      .build_violation(constraint.message)
      .add_parameter("{{ value }}", value)
      .code(AVD::Constraints::IsTrue::NOT_TRUE_ERROR)
      .add
  end
end
