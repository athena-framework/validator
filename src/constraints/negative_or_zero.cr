class Athena::Validator::Constraints::NegativeOrZero < Athena::Validator::Constraint
  include Athena::Validator::Constraints::AbstractComparison(Int32)

  @@error_names = {
    AVD::Constraints::LessThan::TOO_HIGH_ERROR => "TOO_HIGH_ERROR",
  }

  def validated_by : AVD::ConstraintValidator.class
    AVD::Constraints::LessThanOrEqual::Validator
  end

  def initialize(
    message : String = "This value should be negative or zero.",
    groups : Array(String)? = nil,
    payload : Hash(String, String)? = nil
  )
    super Int32.zero, message, groups, payload
  end
end
