struct Athena::Validator::Constraints::Size(B, E) < Athena::Validator::Constraint
  TOO_SHORT_ERROR = "8ba31c71-1b37-4b76-8bc9-66896589b01f"
  TOO_LONG_ERROR  = "a1fa7a63-ea3b-46a0-adcc-5e1bcc26f73a"

  @@error_names = {
    TOO_SHORT_ERROR => "TOO_SHORT_ERROR",
    TOO_LONG_ERROR  => "TOO_LONG_ERROR",
  }

  getter range : ::Range(B, E)
  getter min_message : String
  getter max_message : String
  getter exact_message : String

  def initialize(
    @range : ::Range(B, E),
    @min_message : String = "This value is too short. It should have {{ limit }} {{ type }} or more.|This value is too short. It should have {{ limit }} {{ type }}s or more.",
    @max_message : String = "This value is too long. It should have {{ limit }} {{ type }} or less.|This value is too long. It should have {{ limit }} {{ type }}s or less.",
    @exact_message : String = "This value should have exactly {{ limit }} {{ type }}.|This value should have exactly {{ limit }} {{ type }}s.",
    groups : Array(String)? = nil,
    payload : Hash(String, String)? = nil
  )
    super "", groups, payload
  end

  struct Validator < Athena::Validator::ConstraintValidator
    # :inherit:
    def validate(value : String | Indexable, constraint : AVD::Constraints::Size) : Nil
      return if value.nil?

      size = value.size

      range = constraint.range

      min = range.begin
      max = range.end

      if max && size > max
        self.context
          .build_violation(min == max ? constraint.exact_message : constraint.max_message)
          .add_parameter("{{ value }}", value)
          .add_parameter("{{ limit }}", max)
          .add_parameter("{{ type }}", value.is_a?(String) ? "character" : "item")
          .invalid_value(value)
          .plural(max)
          .code(TOO_LONG_ERROR)
          .add
      end

      if min && size < min
        self.context
          .build_violation(min == max ? constraint.exact_message : constraint.min_message)
          .add_parameter("{{ value }}", value)
          .add_parameter("{{ limit }}", min)
          .add_parameter("{{ type }}", value.is_a?(String) ? "character" : "item")
          .invalid_value(value)
          .plural(min)
          .code(TOO_SHORT_ERROR)
          .add
      end
    end
  end
end
