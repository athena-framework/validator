struct Athena::Validator::Constraints::Positive < Athena::Validator::Constraint
  include Athena::Validator::Constraints::AbstractComparison(Int32)

  configure validator: Athena::Validator::Constraints::GreaterThanValidator

  def initialize(
    message : String = "This value should be positive.",
    groups : Array(String)? = nil,
    payload : Hash(String, String)? = nil
  )
    super Int32.zero, message, groups, payload
  end
end
