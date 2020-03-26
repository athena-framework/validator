struct Athena::Validator::Constraints::IsFalse < Athena::Validator::Constraint
  configure

  NOT_FALSE_ERROR = "42533c7e-4857-4508-99ea-b19c62b45e47"

  DEFAULT_ERROR_MESSAGE = "This value should be false."

  initializer
end
