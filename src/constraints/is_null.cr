class Athena::Validator::Constraints::IsNull < Athena::Validator::Constraint
  DEFAULT_ERROR_MESSAGE = "This value should be null."
  NOT_NULL_ERROR        = "2c88e3c7-9275-4b9b-81b4-48c6c44b1804"

  @@error_names = {
    NOT_NULL_ERROR => "NOT_NULL_ERROR",
  }

  initializer

  struct Validator < Athena::Validator::ConstraintValidator
    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::IsNull) : Nil
      return if value.nil?

      self.context
        .build_violation(constraint.message)
        .add_parameter("{{ value }}", value)
        .code(NOT_NULL_ERROR)
        .add
    end
  end
end
