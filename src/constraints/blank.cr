class Athena::Validator::Constraints::Blank < Athena::Validator::Constraint
  NOT_BLANK_ERROR = "c815f901-c581-4fb7-a85d-b8c5bc757959"

  @@error_names = {
    NOT_BLANK_ERROR => "NOT_BLANK_ERROR",
  }

  def initialize(
    message : String = "This value should be blank.",
    groups : Array(String)? = nil,
    payload : Hash(String, String)? = nil
  )
    super message, groups, payload
  end

  struct Validator < Athena::Validator::ConstraintValidator
    include Basic

    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::Blank) : Nil
      return if value.nil?
      return if value.responds_to?(:blank?) && value.blank?

      self
        .context
        .build_violation(constraint.message, NOT_BLANK_ERROR, value)
        .add
    end
  end
end
