struct Athena::Validator::Constraints::GreaterThanOrEqual(ValueType) < Athena::Validator::Constraints::AbstractComparison
  configure

  TOO_LOW_ERROR         = "e09e52d0-b549-4ba1-8b4e-420aad76f0de"
  DEFAULT_ERROR_MESSAGE = "This value should be greater than or equal to {{ compared_value }}."
end
