struct Athena::Validator::Constraints::IsTrue < Athena::Validator::Constraint
  configure

  NOT_TRUE_ERROR = "d68a0178-2916-4fd4-9c04-67dc4d849619"

  DEFAULT_ERROR_MESSAGE = "This value should be true."

  initializer
end
