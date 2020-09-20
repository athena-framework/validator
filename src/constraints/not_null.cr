class Athena::Validator::Constraints::NotNull < Athena::Validator::Constraint
  DEFAULT_ERROR_MESSAGE = "This value should not be null."
  IS_NULL_ERROR         = "c7e77b14-744e-44c0-aa7e-391c69cc335c"

  @@error_names = {
    IS_NULL_ERROR => "IS_NULL_ERROR",
  }

  initializer

  struct Validator < Athena::Validator::ConstraintValidator
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
