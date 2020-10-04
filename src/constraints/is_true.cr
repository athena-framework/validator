class Athena::Validator::Constraints::IsTrue < Athena::Validator::Constraint
  NOT_TRUE_ERROR = "beabd93e-3673-4dfc-8796-01bd1504dd19"

  @@error_names = {
    NOT_TRUE_ERROR => "NOT_TRUE_ERROR",
  }

  def initialize(
    message : String = "This value should be true.",
    groups : Array(String) | String | Nil = nil,
    payload : Hash(String, String)? = nil
  )
    super message, groups, payload
  end

  struct Validator < Athena::Validator::ConstraintValidator
    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::IsTrue) : Nil
      return if value.nil? || value == true

      self
        .context
        .build_violation(constraint.message, NOT_TRUE_ERROR, value)
        .add
    end
  end
end
