module Athena::Validator::Constraints::AbstractComparison(ValueType)
  getter value : ValueType
  getter value_type : ValueType.class = ValueType

  def initialize(
    @value : ValueType,
    message : String = default_error_message,
    groups : Array(String)? = nil,
    payload : Hash(String, String)? = nil
  )
    super message, groups, payload
  end
end
