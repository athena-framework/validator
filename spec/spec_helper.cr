require "spec"
require "../src/athena-validator"

def get_violation(message : String, *, invalid_value : _ = nil, root : _ = nil, property_path : String = "", code : String = "") : AVD::Violation::ConstraintViolation
  AVD::Violation::ConstraintViolation.new message, message, Hash(String, String).new, nil, root, nil, property_path, invalid_value, code, nil
end
