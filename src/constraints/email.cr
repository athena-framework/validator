class Athena::Validator::Constraints::Email < Athena::Validator::Constraint
  enum Mode
    # Validates the email against the [HTML5 input pattern](https://html.spec.whatwg.org/multipage/input.html#valid-e-mail-address).
    HTML5
    Loose

    # TODO: Implement this mode.
    # STRICT

    def pattern : ::Regex
      case self
      in .html5? then /^[a-zA-Z0-9.!\#$\%&\'*+\\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$/
      in .loose? then /^.+\@\S+\.\S+$/
      end
    end
  end

  INVALID_FORMAT_ERROR = "ad9d877d-9ad1-4dd7-b77b-e419934e5910"

  @@error_names = {
    INVALID_FORMAT_ERROR => "INVALID_FORMAT_ERROR",
  }

  getter mode : AVD::Constraints::Email::Mode

  def initialize(
    @mode : AVD::Constraints::Email::Mode = :loose,
    message : String = "This value is not a valid email address.",
    groups : Array(String)? = nil,
    payload : Hash(String, String)? = nil
  )
    super message, groups, payload
  end

  struct Validator < Athena::Validator::ConstraintValidator
    include Basic

    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::Email) : Nil
      value = value.to_s

      return if value.nil? || value.empty?
      return if value.matches? constraint.mode.pattern

      self
        .context
        .build_violation(constraint.message, INVALID_FORMAT_ERROR, value)
        .add
    end
  end
end
