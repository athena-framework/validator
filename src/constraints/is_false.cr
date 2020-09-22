class Athena::Validator::Constraints::IsFalse < Athena::Validator::Constraint
  DEFAULT_ERROR_MESSAGE = "This value should be false."
  NOT_FALSE_ERROR       = "55c076a0-dbaf-453c-90cf-b94664276dbc"

  @@error_names = {
    NOT_FALSE_ERROR => "NOT_FALSE_ERROR",
  }

  initializer

  struct Validator < Athena::Validator::ConstraintValidator
    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::IsFalse) : Nil
      return if value.nil? || value == false

      self.context
        .build_violation(constraint.message)
        .add_parameter("{{ value }}", value)
        .code(NOT_FALSE_ERROR)
        .add
    end
  end
end
