struct Athena::Validator::Constraints::NotBlank < Athena::Validator::Constraint
  configure

  IS_BLANK_ERROR = "0d0c3254-3642-4cb0-9882-46ee5918e6e3"

  getter? allow_nil : Bool

  DEFAULT_ERROR_MESSAGE = "This value should not be blank."

  initializer(allow_nil : Bool = false)
end
