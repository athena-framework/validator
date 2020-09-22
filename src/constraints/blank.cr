class Athena::Validator::Constraints::Blank < Athena::Validator::Constraint
  DEFAULT_ERROR_MESSAGE = "This value should be blank."
  NOT_BLANK_ERROR       = "c815f901-c581-4fb7-a85d-b8c5bc757959"

  @@error_names = {
    NOT_BLANK_ERROR => "NOT_BLANK_ERROR",
  }

  initializer

  struct Validator < Athena::Validator::ConstraintValidator
    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::Blank) : Nil
      return if value.nil?
      return if value.responds_to?(:blank?) && value.blank?

      self.context
        .build_violation(constraint.message)
        .add_parameter("{{ value }}", value)
        .code(NOT_BLANK_ERROR)
        .add
    end
  end
end
