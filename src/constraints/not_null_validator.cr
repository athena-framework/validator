struct Athena::Validator::Constraints::NotNullValidator < Athena::Validator::ConstraintValidator
  # :inherit:
  def validate(value : _, constraint : AVD::Constraints::NotNull) : Nil
    return unless value.nil?

    self.context
      .build_violation(constraint.message)
      .add_parameter("{{ value }}", value)
      .code(AVD::Constraints::NotNull::IS_NULL_ERROR)
      .add
  end
end
