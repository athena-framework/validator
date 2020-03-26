struct Athena::Validator::Constraints::Blank < Athena::Validator::Constraint
  configure

  NOT_BLANK_ERROR = "769d69bc-001e-4fb5-b68c-209ce7ce8758"

  initializer("This value should be blank.")
end
