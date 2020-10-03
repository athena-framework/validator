class Athena::Validator::Constraints::PositiveOrZero < Athena::Validator::Constraints::GreaterThanOrEqual(Int32)
  def validated_by : AVD::ConstraintValidator.class
    AVD::Constraints::GreaterThanOrEqual::Validator
  end

  def initialize(
    message : String = "This value should be positive or zero.",
    groups : Array(String) | String | Nil = nil,
    payload : Hash(String, String)? = nil
  )
    super Int32.zero, message, groups, payload
  end
end
