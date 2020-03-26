struct Athena::Validator::Constraints::NotNull < Athena::Validator::Constraint
  configure

  IS_NULL_ERROR = "c7e77b14-744e-44c0-aa7e-391c69cc335c"

  DEFAULT_ERROR_MESSAGE = "This value should not be null."

  initializer
end
