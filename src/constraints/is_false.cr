class Athena::Validator::Constraints::IsFalse < Athena::Validator::Constraint
  NOT_FALSE_ERROR = "55c076a0-dbaf-453c-90cf-b94664276dbc"

  @@error_names = {
    NOT_FALSE_ERROR => "NOT_FALSE_ERROR",
  }

  def initialize(
    message : String = "This value should be false.",
    groups : Array(String) | String | Nil = nil,
    payload : Hash(String, String)? = nil
  )
    super message, groups, payload
  end

  struct Validator < Athena::Validator::ConstraintValidator
    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::IsFalse) : Nil
      return if value.nil? || value == false

      self
        .context
        .build_violation(constraint.message, NOT_FALSE_ERROR, value)
        .add
    end
  end
end
