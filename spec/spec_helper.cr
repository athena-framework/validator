require "spec"
require "../src/athena-validator"

struct MockConstraint < AVD::Constraint
  configure
end

struct MockConstraintValidator < AVD::ConstraintValidator
end

module Fake
  struct DefaultConstraint < AVD::Constraint
    configure
  end

  struct DefaultConstraintValidator < AVD::ConstraintValidator
  end
end

struct CustomConstraint < AVD::Constraint
  configure annotation: CustomConstraintAnotation, validator: MyValidator, targets: ["foo"]

  FAKE_ERROR = "abc123"
  BLAH       = "BLAH"
end

struct MyValidator < AVD::ConstraintValidator
end

def get_violation(message : String, *, invalid_value : _ = nil, root : _ = nil, property_path : String = "", code : String = "") : AVD::Violation::ConstraintViolation
  AVD::Violation::ConstraintViolation.new message, message, Hash(String, String).new, nil, root, nil, property_path, invalid_value, code, nil
end
