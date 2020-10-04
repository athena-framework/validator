class Athena::Validator::Constraints::Positive < Athena::Validator::Constraints::GreaterThan(Int32)
  def validated_by : AVD::ConstraintValidator.class
    AVD::Constraints::GreaterThan::Validator
  end

  def initialize(
    message : String = "This value should be positive.",
    groups : Array(String) | String | Nil = nil,
    payload : Hash(String, String)? = nil
  )
    super Int32.zero, message, groups, payload
  end
end
