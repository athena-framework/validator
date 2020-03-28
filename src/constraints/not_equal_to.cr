struct Athena::Validator::Constraints::NotEqualTo(ValueType) < Athena::Validator::Constraints::AbstractComparison
  configure

  IS_EQUAL_ERROR        = "984a0525-d73e-40c0-81c2-2ecbca7e4c96"
  DEFAULT_ERROR_MESSAGE = "This value should not be equal to {{ compared_value }}."
end
