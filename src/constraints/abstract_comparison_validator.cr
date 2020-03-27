abstract struct Athena::Validator::Constraints::AbstractComparisonValidator < Athena::Validator::ConstraintValidator
  protected abstract def compare_values(actual : _, expected : _) : Bool
  protected abstract def error_code : String

  # :inherit:
  def validate(value : _, constraint : AVD::Constraints::AbstractComparison) : Nil
    return if value.nil?

    compared_value = constraint.value

    return if self.compare_values value, compared_value

    self.context
      .build_violation(constraint.message)
      .add_parameter("{{ value }}", value)
      .add_parameter("{{ compared_value }}", compared_value)
      .add_parameter("{{ compared_value_type }}", constraint.value_type)
      .code(self.error_code)
      .add
  end
end
