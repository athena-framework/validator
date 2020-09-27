class Athena::Validator::Constraints::NotNull < Athena::Validator::Constraint
  IS_NULL_ERROR = "c7e77b14-744e-44c0-aa7e-391c69cc335c"

  @@error_names = {
    IS_NULL_ERROR => "IS_NULL_ERROR",
  }

  def initialize(
    message : String = "This value should not be null.",
    groups : Array(String)? = nil,
    payload : Hash(String, String)? = nil
  )
    super message, groups, payload
  end

  struct Validator < Athena::Validator::ConstraintValidator
    include Basic

    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::NotNull) : Nil
      return unless value.nil?

      self.context
        .build_violation(constraint.message)
        .add_parameter("{{ value }}", value)
        .code(IS_NULL_ERROR)
        .add
    end
  end
end
