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

# struct CustomConstraint < AVD::Constraint

#   protected def default_error_message : String
#     DEFAULT_ERROR_MESSAGE
#   end
# end

# struct MyValidator < AVD::ConstraintValidator
# end

# struct TestClassCallback
#   include AVD::Validatable

#   class_setter class_callback : Proc(AVD::Constraints::Callback::Container, Nil)? = nil
#   class_setter group : Array(String)? = ["group"]

#   @[Assert::Callback(groups: @@group)]
#   def self.class_callback(container : AVD::Constraints::Callback::Container) : Nil
#     @@class_callback.not_nil!.call container
#   end
# end

# Spec.before_each do
#   TestClassCallback.group = ["group"]
#   TestClassCallback.class_callback = nil
# end

# struct TestPropertyCallback
#   include AVD::Validatable

#   def validation_metadata : AVD::Metadata::ClassMetadata
#     class_metadata = AVD::Metadata::ClassMetadata.new self.class

#     class_metadata.add_property_constraint(
#       AVD::Metadata::PropertyMetadata(String).new(->{ @name }, TestPropertyCallback, "name"),
#       Athena::Validator::Constraints::Callback.new @callback.not_nil!, groups: [@group1]
#     )

#     if callback2 = @callback2
#       class_metadata.add_property_constraint(
#         AVD::Metadata::PropertyMetadata(Int32).new(->{ @age }, TestPropertyCallback, "age"),
#         Athena::Validator::Constraints::Callback.new callback2, groups: [@group2]
#       )
#     end

#     class_metadata
#   end

#   property name : String
#   property age : Int32
#   setter callback : AVD::Constraints::Callback::CallbackProc? = nil
#   setter callback2 : AVD::Constraints::Callback::CallbackProc? = nil

#   def initialize(@name : String, @age : Int32 = 1, *, @group1 : String = "group", @group2 : String = "group"); end
# end

# TODO: Create Athena::Validator::Spec module
