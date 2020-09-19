struct Athena::Validator::Constraints::Range(B, E) < Athena::Validator::Constraint
  NOT_IN_RANGE_ERROR = "7e62386d-30ae-4e7c-918f-1b7e571c6d69"
  TOO_HIGH_ERROR     = "5d9aed01-ac49-4d8e-9c16-e4aab74ea774"
  TOO_LOW_ERROR      = "f0316644-882e-4779-a404-ee7ac97ddecc"

  @@error_names = {
    NOT_IN_RANGE_ERROR => "NOT_IN_RANGE_ERROR",
    TOO_HIGH_ERROR     => "TOO_HIGH_ERROR",
    TOO_LOW_ERROR      => "TOO_LOW_ERROR",
  }

  getter range : ::Range(B, E)
  getter not_in_range_message : String
  getter min_message : String
  getter max_message : String

  def initialize(
    @range : ::Range(B, E),
    @not_in_range_message : String = "This value should be between {{ min }} and {{ max }}.",
    @min_message : String = "This value should be {{ limit }} or more.",
    @max_message : String = "This value should be {{ limit }} or less.",
    groups : Array(String)? = nil,
    payload : Hash(String, String)? = nil
  )
    super "", groups, payload
  end

  struct Validator < Athena::Validator::ConstraintValidator
    # :inherit:
    #
    # ameba:disable Metrics/CyclomaticComplexity
    def validate(value : Number | Time | Nil, constraint : AVD::Constraints::Range) : Nil
      return if value.nil?

      range = constraint.range

      min = range.begin
      max = range.end

      case {value, min, max}
      when {Number, Number::Primitive?, Number::Primitive?}
        return self.add_not_in_range_violation constraint, value, min, max if min && max && (value < min || value > max)
        return self.add_too_high_violation constraint, value, max if max && value > max

        add_too_low_violation constraint, value, min if min && value < min
      when {Time, Time?, Time?}
        return self.add_not_in_range_violation constraint, value, min, max if min && max && (value < min || value > max)
        return self.add_too_high_violation constraint, value, max if max && value > max

        add_too_low_violation constraint, value, min if min && value < min
      end
    end

    def validate(value : _, constraint : AVD::Constraints::Range) : Nil
      raise AVD::Exceptions::UnexpectedValueError.new value, "Number | Time"
    end

    private def add_not_in_range_violation(constraint, value, min, max) : Nil
      self.context
        .build_violation(constraint.not_in_range_message)
        .add_parameter("{{ value }}", value)
        .add_parameter("{{ min }}", min)
        .add_parameter("{{ max }}", max)
        .code(NOT_IN_RANGE_ERROR)
        .add
    end

    private def add_too_high_violation(constraint, value, max) : Nil
      self.context
        .build_violation(constraint.max_message)
        .add_parameter("{{ value }}", value)
        .add_parameter("{{ limit }}", max)
        .code(TOO_HIGH_ERROR)
        .add
    end

    private def add_too_low_violation(constraint, value, min) : Nil
      self.context
        .build_violation(constraint.min_message)
        .add_parameter("{{ value }}", value)
        .add_parameter("{{ limit }}", min)
        .code(TOO_LOW_ERROR)
        .add
    end
  end
end
