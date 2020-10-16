class Athena::Validator::Constraints::Negative < Athena::Validator::Constraints::LessThan(Int32)
  def initialize(
    message : String = "This value should be negative.",
    groups : Array(String) | String | Nil = nil,
    payload : Hash(String, String)? = nil
  )
    super Int32.zero, message, groups, payload
  end

  def validated_by : AVD::ConstraintValidator.class
    AVD::Constraints::LessThan::Validator
  end
end
