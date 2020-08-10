struct Athena::Validator::Constraints::PositiveOrZero < Athena::Validator::Constraint
  include Athena::Validator::Constraints::AbstractComparison(Int32)

  @@error_names = {
    AVD::Constraints::GreaterThanOrEqual::TOO_LOW_ERROR => "TOO_LOW_ERROR",
  }

  def validated_by : AVD::ConstraintValidator.class
    AVD::Constraints::GreaterThanOrEqual::Validator
  end

  def initialize(
    message : String = "This value should be positive or zero.",
    groups : Array(String)? = nil,
    payload : Hash(String, String)? = nil
  )
    super Int32.zero, message, groups, payload
  end
end
