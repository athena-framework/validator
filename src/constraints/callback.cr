struct Athena::Validator::Constraints::Callback < Athena::Validator::Constraint
  configure targets: ["property", "class"]

  getter callback : Proc(AVD::ExecutionContextInterface, Hash(String, String)?, Nil)

  initializer("", callback : Proc(AVD::ExecutionContextInterface, Hash(String, String)?, Nil))
end
