class Athena::Validator::Constraints::IsTrue < Athena::Validator::Constraint
  DEFAULT_ERROR_MESSAGE = "This value should be true."
  NOT_TRUE_ERROR        = "beabd93e-3673-4dfc-8796-01bd1504dd19"

  @@error_names = {
    NOT_TRUE_ERROR => "NOT_TRUE_ERROR",
  }

  initializer

  struct Validator < Athena::Validator::ConstraintValidator
    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::IsTrue) : Nil
      return if value.nil? || value == true

      self.context
        .build_violation(constraint.message)
        .add_parameter("{{ value }}", value)
        .code(NOT_TRUE_ERROR)
        .add
    end
  end
end
