module Athena::Validator::Violation::ConstraintViolationInterface
  abstract def message : String
  abstract def message_template : String?
  abstract def parameters : Hash(String, String)
  abstract def plural : Int32?
  abstract def root
  abstract def property_path : String
  abstract def invalid_value
  abstract def code : String
  abstract def constraint : AVD::Constraint
  abstract def cause : String?

  abstract def to_s(io : IO) : Nil
end
