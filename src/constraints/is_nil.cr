class Athena::Validator::Constraints::IsNil < Athena::Validator::Constraint
  NOT_NIL_ERROR = "2c88e3c7-9275-4b9b-81b4-48c6c44b1804"

  @@error_names = {
    NOT_NIL_ERROR => "NOT_NIL_ERROR",
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
    def validate(value : _, constraint : AVD::Constraints::IsNil) : Nil
      return if value.nil?

      self.context.add_violation constraint.message, NOT_NIL_ERROR, value
    end
  end
end