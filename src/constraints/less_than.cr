struct Athena::Validator::Constraints::LessThan(ValueType) < Athena::Validator::Constraints::AbstractComparison
  configure

  TOO_HIGH_ERROR        = "d9fbedb3-c576-45b5-b4dc-996030349bbf"
  DEFAULT_ERROR_MESSAGE = "This value should be less than {{ compared_value }}."
end
