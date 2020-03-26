struct Athena::Validator::Constraints::IsTrue < Athena::Validator::Constraint
  configure

  NOT_TRUE_ERROR = "d68a0178-2916-4fd4-9c04-67dc4d849619"

  initializer("This value should be true.")
end
