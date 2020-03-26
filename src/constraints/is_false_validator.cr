struct Athena::Validator::Constraints::IsFalseValidator < Athena::Validator::ConstraintValidator
  # :inherit:
  def validate(value : _, constraint : AVD::Constraints::IsFalse) : Nil
    return unless value

    self.context
      .build_violation(constraint.message)
      .add_parameter("{{ value }}", value)
      .code(AVD::Constraints::IsFalse::NOT_FALSE_ERROR)
      .add
  end
end
