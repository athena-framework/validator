struct Athena::Validator::Constraints::Valid < Athena::Validator::Constraint
  configure

  getter? traverse : Bool

  initializer(traverse : Bool = true)
end
