struct Athena::Validator::Constraints::RangeValidator < Athena::Validator::ConstraintValidator
  # :inherit:
  def validate(value : Number | Time | Nil, constraint : AVD::Constraints::Range) : Nil
    return if value.nil?

    range = constraint.range

    min = range.begin
    max = range.end

    if min && max && (AVD::Compare.lt(value, min) || AVD::Compare.gt(value, max))
      self.context
        .build_violation(constraint.not_in_range_message)
        .add_parameter("{{ value }}", value)
        .add_parameter("{{ min }}", min)
        .add_parameter("{{ max }}", max)
        .code(AVD::Constraints::Range::NOT_IN_RANGE_ERROR)
        .add

      return
    end

    if AVD::Compare.gt(value, max)
      self.context
        .build_violation(constraint.max_message)
        .add_parameter("{{ value }}", value)
        .add_parameter("{{ limit }}", max)
        .code(AVD::Constraints::Range::TOO_HIGH_ERROR)
        .add

      return
    end

    if AVD::Compare.lt(value, min)
      self.context
        .build_violation(constraint.min_message)
        .add_parameter("{{ value }}", value)
        .add_parameter("{{ limit }}", min)
        .code(AVD::Constraints::Range::TOO_LOW_ERROR)
        .add
    end
  end
end
