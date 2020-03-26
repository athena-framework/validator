struct Athena::Validator::Constraints::IsNullValidator < Athena::Validator::ConstraintValidator
  # :inherit:
  def validate(value : _, constraint : AVD::Constraints::IsNull) : Nil
    return if value.nil?

    self.context
      .build_violation(constraint.message)
      .add_parameter("{{ value }}", value)
      .code(AVD::Constraints::IsNull::NOT_NULL_ERROR)
      .add
  end
end
