struct Athena::Validator::Constraints::IsNull < Athena::Validator::Constraint
  configure

  NOT_NULL_ERROR = "e0e68487-e09c-4885-bcff-514af9f89a7f"

  initializer("This value should be null.")
end
