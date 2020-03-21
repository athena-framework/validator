struct Athena::Validator::Constraints::NotBlank < Athena::Validator::Constraint
  IS_BLANK_ERROR = "0d0c3254-3642-4cb0-9882-46ee5918e6e3"

  getter? allow_nil : Bool

  def initialize(message : String = "This value should not be blank.", @allow_nil : Bool = false)
    super message
  end
end
