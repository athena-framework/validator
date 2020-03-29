struct Athena::Validator::Constraints::GreaterThan(ValueType) < Athena::Validator::Constraint
  include Athena::Validator::Constraints::AbstractComparison(ValueType)

  configure

  TOO_LOW_ERROR         = "a221096d-d125-44e8-a865-4270379ac11a"
  DEFAULT_ERROR_MESSAGE = "This value should be greater than {{ compared_value }}."
end
