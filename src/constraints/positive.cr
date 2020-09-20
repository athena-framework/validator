class Athena::Validator::Constraints::Positive < Athena::Validator::Constraint
  include Athena::Validator::Constraints::AbstractComparison(Int32)

  @@error_names = {
    AVD::Constraints::GreaterThan::TOO_LOW_ERROR => "TOO_LOW_ERROR",
  }

  def validated_by : AVD::ConstraintValidator.class
    AVD::Constraints::GreaterThan::Validator
  end

  def initialize(
    message : String = "This value should be positive.",
    groups : Array(String)? = nil,
    payload : Hash(String, String)? = nil
  )
    super Int32.zero, message, groups, payload
  end
end
