require "spec"
require "../src/athena-validator"
require "../src/spec"

ASPEC.run_all

struct MockConstraint < AVD::Constraint
  def validated_by
    MockConstraintValidator
  end
end

struct MockConstraintValidator < AVD::ConstraintValidator
end

# module Fake
#   struct DefaultConstraint < AVD::Constraint
#     configure
#   end

#   struct DefaultConstraintValidator < AVD::ConstraintValidator
#   end
# end

struct CustomConstraint < AVD::Constraint
  protected def default_error_message : String
    DEFAULT_ERROR_MESSAGE
  end

  struct Validator < Athena::Validator::ConstraintValidator
    def validate(value : _, constraint : AVD::Constraints::NotNull) : Nil
    end
  end
end

# struct MyValidator < AVD::ConstraintValidator
# end

struct TestClassCallback
  include AVD::Validatable

  class_setter class_callback : AVD::Constraints::Callback::CallbackProc? = nil
  class_setter group : Array(String)? = ["group"]

  @[Assert::Callback(groups: @@group)]
  def self.validate(object : AVD::Constraints::Callback::Value, context : AVD::ExecutionContextInterface, payload : Hash(String, String)?) : Nil
    @@class_callback.not_nil!.call object, context, payload
  end
end

Spec.before_each do
  TestClassCallback.group = ["group"]
  TestClassCallback.class_callback = nil
end

struct TestPropertyCallback
  include AVD::Validatable

  def validation_metadata : AVD::Metadata::ClassMetadata
    class_metadata = AVD::Metadata::ClassMetadata.new self.class

    class_metadata.add_property_constraint(
      AVD::Metadata::PropertyMetadata(String, TestPropertyCallback).new("name"),
      AVD::Constraints::Callback.new callback: @callback, groups: [@group1]
    )

    if callback2 = @callback2
      class_metadata.add_property_constraint(
        AVD::Metadata::PropertyMetadata(Int32, TestPropertyCallback).new("age"),
        AVD::Constraints::Callback.new callback: callback2, groups: [@group2]
      )
    end

    class_metadata
  end

  property name : String
  property age : Int32
  setter callback : AVD::Constraints::Callback::CallbackProc? = nil
  setter callback2 : AVD::Constraints::Callback::CallbackProc? = nil

  def initialize(@name : String, @age : Int32 = 1, *, @group1 : String = "group", @group2 : String = "group"); end
end
