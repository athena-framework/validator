struct Athena::Validator::Constraints::NotBlank < Athena::Validator::Constraint
  DEFAULT_ERROR_MESSAGE = "This value should not be blank."
  IS_BLANK_ERROR        = "0d0c3254-3642-4cb0-9882-46ee5918e6e3"

  getter? allow_nil : Bool

  initializer(allow_nil : Bool = false)

  protected def default_error_message : String
    DEFAULT_ERROR_MESSAGE
  end

  struct Validator < Athena::Validator::ConstraintValidator
    # :inherit:
    def validate(value : String?, constraint : AVD::Constraints::NotBlank) : Nil
      validate_value(value, constraint) do |v|
        v.blank?
      end
    end

    # :inherit:
    def validate(value : Bool?, constraint : AVD::Constraints::NotBlank) : Nil
      validate_value(value, constraint) do |v|
        v == false
      end
    end

    # :inherit:
    def validate(value : Indexable?, constraint : AVD::Constraints::NotBlank) : Nil
      validate_value(value, constraint) do |v|
        v.empty?
      end
    end

    private def validate_value(value : _, constraint : AVD::Constraints::NotBlank, & : -> Bool) : Nil
      return if value.nil? && constraint.allow_nil?

      if value.nil? || yield value
        self.context
          .build_violation(constraint.message)
          .add_parameter("{{ value }}", value)
          .code(AVD::Constraints::NotBlank::IS_BLANK_ERROR)
          .add
      end
    end
  end
end
