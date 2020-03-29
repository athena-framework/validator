module Athena::Validator::Constraints::AbstractComparison(ValueType)
  private DEFAULT_ERROR_MESSAGE = ""

  getter value : ValueType
  getter value_type : ValueType.class = ValueType

  def initialize(
    @value : ValueType,
    message : String = DEFAULT_ERROR_MESSAGE,
    groups : Array(String)? = nil,
    payload : Hash(String, String)? = nil
  )
    super message, groups, payload
  end
end
