class Athena::Validator::Constraints::Regex < Athena::Validator::Constraint
  REGEX_FAILED_ERROR = "108987a0-2d81-44a0-b8d4-1c7ab8815343"

  @@error_names = {
    REGEX_FAILED_ERROR => "REGEX_FAILED_ERROR",
  }

  getter pattern : ::Regex
  getter? match : Bool

  def initialize(
    @pattern : ::Regex,
    @match : Bool = true,
    message : String = "This value is not valid.",
    groups : Array(String) | String | Nil = nil,
    payload : Hash(String, String)? = nil
  )
    super message, groups, payload
  end

  struct Validator < Athena::Validator::ConstraintValidator
    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::Regex) : Nil
      value = value.to_s

      return if value.nil? || value.empty?
      return unless constraint.match? ^ value.matches? constraint.pattern

      self.context.add_violation constraint.message, REGEX_FAILED_ERROR, value
    end
  end
end
