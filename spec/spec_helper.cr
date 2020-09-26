require "spec"
require "../src/athena-validator"
require "../src/spec"

ASPEC.run_all

class MockConstraint < AVD::Constraint
  def validated_by
    MockConstraintValidator
  end
end

struct MockConstraintValidator < AVD::ConstraintValidator
end

class CustomConstraint < AVD::Constraint
  @@error_names = {
    "abc123" => "FAKE_ERROR",
  }

  struct Validator < Athena::Validator::ConstraintValidator
    def validate(value : _, constraint : CustomConstraint) : Nil
    end
  end
end

struct TestClassCallback
  include AVD::Validatable

  class_setter class_callback : AVD::Constraints::Callback::CallbackProc? = nil
  class_setter group : Array(String)? = ["group"]

  def self.validation_class_metadata : AVD::Metadata::ClassMetadata
    class_metadata = AVD::Metadata::ClassMetadata(TestPropertyCallback).new self

    class_metadata.add_constraint AVD::Constraints::Callback.new callback: @@class_callback, groups: @@group

    class_metadata
  end
end

Spec.before_each do
  TestClassCallback.group = ["group"]
  TestClassCallback.class_callback = nil

  TestPropertyCallback.group1 = "group"
  TestPropertyCallback.group2 = "group"

  TestPropertyCallback.callback = nil
  TestPropertyCallback.callback2 = nil
end

struct TestPropertyCallback
  include AVD::Validatable

  class_setter group1 : String = "group"
  class_setter group2 : String = "group"

  class_setter callback : AVD::Constraints::Callback::CallbackProc?
  class_setter callback2 : AVD::Constraints::Callback::CallbackProc? = nil

  def self.validation_class_metadata : AVD::Metadata::ClassMetadata
    class_metadata = AVD::Metadata::ClassMetadata(TestPropertyCallback).new self

    class_metadata.add_property_constraint(
      AVD::Metadata::PropertyMetadata(TestPropertyCallback).new("name"),
      AVD::Constraints::Callback.new callback: @@callback, groups: [@@group1]
    )

    if callback2 = @@callback2
      class_metadata.add_property_constraint(
        AVD::Metadata::PropertyMetadata(TestPropertyCallback).new("age"),
        AVD::Constraints::Callback.new callback: callback2, groups: [@@group2]
      )
    end

    class_metadata
  end

  property name : String
  property age : Int32

  def initialize(@name : String, @age : Int32 = 1); end
end

def get_violation(message : String, *, invalid_value : _ = nil, root : _ = nil, property_path : String = "", code : String = "") : AVD::Violation::ConstraintViolation
  AVD::Violation::ConstraintViolation.new message, message, Hash(String, String).new, root, property_path, AVD::ValueContainer.new(invalid_value), code: code
end
