struct Athena::Validator::Constraints::Range(B, E) < Athena::Validator::Constraint
  getter range : ::Range(B, E)
  getter not_in_range_message : String
  getter min_message : String
  getter max_message : String

  NOT_IN_RANGE_ERROR = "7e62386d-30ae-4e7c-918f-1b7e571c6d69"
  TOO_HIGH_ERROR     = "5d9aed01-ac49-4d8e-9c16-e4aab74ea774"
  TOO_LOW_ERROR      = "f0316644-882e-4779-a404-ee7ac97ddecc"

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
    def validate(value : Number | Time | Nil, constraint : AVD::Constraints::Range) : Nil
      return if value.nil?

      range = constraint.range

      min = range.begin
      max = range.end

      if min && max && !range.includes?(value)
        self.context
          .build_violation(constraint.not_in_range_message)
          .add_parameter("{{ value }}", value)
          .add_parameter("{{ min }}", min)
          .add_parameter("{{ max }}", max)
          .code(NOT_IN_RANGE_ERROR)
          .add

        return
      end

      if max && value > max
        self.context
          .build_violation(constraint.max_message)
          .add_parameter("{{ value }}", value)
          .add_parameter("{{ limit }}", max)
          .code(TOO_HIGH_ERROR)
          .add

        return
      end

      if min && value < min
        self.context
          .build_violation(constraint.min_message)
          .add_parameter("{{ value }}", value)
          .add_parameter("{{ limit }}", min)
          .code(TOO_LOW_ERROR)
          .add
      end
    end

    def validate(value : _, constraint : AVD::Constraints::Range) : Nil
      raise AVD::Exceptions::UnexpectedValueError.new value, "Number | Time"
    end
  end
end
