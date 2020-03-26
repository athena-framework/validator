struct Athena::Validator::Constraints::BlankValidator < Athena::Validator::ConstraintValidator
  # :inherit:
  def validate(value : _, constraint : AVD::Constraints::Blank) : Nil
    return if value.nil? || value == ""

    self.context
      .build_violation(constraint.message)
      .add_parameter("{{ value }}", value.to_s)
      .code(AVD::Constraints::Blank::NOT_BLANK_ERROR)
      .add
  end
end
