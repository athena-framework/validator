struct Athena::Validator::Constraints::LessThanOrEqual(ValueType) < Athena::Validator::Constraint
  include Athena::Validator::Constraints::AbstractComparison(ValueType)

  configure

  TOO_HIGH_ERROR        = "515a12ff-82f2-4434-9635-137164d5b467"
  DEFAULT_ERROR_MESSAGE = "This value should be less than or equal to {{ compared_value }}."
end
