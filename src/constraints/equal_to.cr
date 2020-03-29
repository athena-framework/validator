struct Athena::Validator::Constraints::EqualTo(ValueType) < Athena::Validator::Constraint
  include Athena::Validator::Constraints::AbstractComparison(ValueType)

  configure

  NOT_EQUAL_ERROR       = "47d83d11-15d5-4267-b469-1444f80fd169"
  DEFAULT_ERROR_MESSAGE = "This value should be equal to {{ compared_value }}."
end
