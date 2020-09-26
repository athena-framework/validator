class Athena::Validator::Constraints::NotBlank < Athena::Validator::Constraint
  IS_BLANK_ERROR = "0d0c3254-3642-4cb0-9882-46ee5918e6e3"

  @@error_names = {
    IS_BLANK_ERROR => "IS_BLANK_ERROR",
  }

  getter? allow_nil : Bool

  def initialize(
    @allow_nil : Bool = false,
    message : String = "This value should not be blank.",
    groups : Array(String)? = nil,
    payload : Hash(String, String)? = nil
  )
    super message, groups, payload
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
          .code(IS_BLANK_ERROR)
          .add
      end
    end
  end
end
