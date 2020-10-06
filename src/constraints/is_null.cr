class Athena::Validator::Constraints::IsNull < Athena::Validator::Constraint
  NOT_NULL_ERROR = "2c88e3c7-9275-4b9b-81b4-48c6c44b1804"

  @@error_names = {
    NOT_NULL_ERROR => "NOT_NULL_ERROR",
  }

  def initialize(
    message : String = "This value should be null.",
    groups : Array(String) | String | Nil = nil,
    payload : Hash(String, String)? = nil
  )
    super message, groups, payload
  end

  struct Validator < Athena::Validator::ConstraintValidator
    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::IsNull) : Nil
      return if value.nil?

      self
        .context
        .build_violation(constraint.message, NOT_NULL_ERROR, value)
        .add
    end
  end
end
