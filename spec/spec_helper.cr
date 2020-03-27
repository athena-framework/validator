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

struct TestClassCallback
  include AVD::Validatable

  class_setter class_callback : Proc(AVD::Constraints::Callback::Container, Nil)? = nil
  class_setter group : Array(String)? = ["group"]

  @[Assert::Callback(groups: @@group)]
  def self.class_callback(container : AVD::Constraints::Callback::Container) : Nil
    @@class_callback.not_nil!.call container
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
      AVD::Metadata::PropertyMetadata(String).new(->{ @name }, TestPropertyCallback, "name"),
      Athena::Validator::Constraints::Callback.new @callback.not_nil!, groups: [@group1]
    )

    if callback2 = @callback2
      class_metadata.add_property_constraint(
        AVD::Metadata::PropertyMetadata(Int32).new(->{ @age }, TestPropertyCallback, "age"),
        Athena::Validator::Constraints::Callback.new callback2, groups: [@group2]
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

struct MockContextualValidator
  include Athena::Validator::Validator::ContextualValidatorInterface

  def at_path(path : String) : AVD::Validator::ContextualValidatorInterface
    self
  end

  def validate(value : _, constraints : Array(Constraint)? = nil, groups : Array(String)? = nil) : AVD::Validator::ContextualValidatorInterface
    self
  end

  def validate_property(object : AVD::Validatable, property_name : String, groups : Array(String)? = nil) : AVD::Validator::ContextualValidatorInterface
    self
  end

  def validate_property_value(object : AVD::Validatable, property_name : String, value : _, groups : Array(String)? = nil) : AVD::Validator::ContextualValidatorInterface
    self
  end

  def violations : AVD::Violation::ConstraintViolationListInterface
    AVD::Violation::ConstraintViolationList.new
  end
end

struct MockValidator
  include Athena::Validator::Validator::ValidatorInterface

  def validate(value : _, constraints : Array(AVD::Constraint)? = nil, groups : Array(String)? = nil) : AVD::Violation::ConstraintViolationListInterface
    AVD::Violation::ConstraintViolationList.new
  end

  def validate_property(object : AVD::Validatable, property_name : String, groups : Array(String)? = nil) : AVD::Violation::ConstraintViolationListInterface
    AVD::Violation::ConstraintViolationList.new
  end

  def validate_property_value(object : AVD::Validatable, property_name : String, value : _, groups : Array(String)? = nil) : AVD::Violation::ConstraintViolationListInterface
    AVD::Violation::ConstraintViolationList.new
  end

  def start_context(root = nil) : AVD::Validator::ContextualValidatorInterface
    MockContextualValidator.new
  end

  def in_context(context : AVD::ExecutionContextInterface) : AVD::Validator::ContextualValidatorInterface
    MockContextualValidator.new
  end
end

# TODO: Create Athena::Validator::Spec module

record ComparableMock, value : Int32 do
  include Comparable(ComparableMock)

  def <=>(other : self) : Int32?
    @value <=> other.value
  end
end

macro define_comparison_spec
  describe "#validate" do
    VALID_COMPARISONS.each do |(actual, expected, message)|
      it "valid #{message}" do
        assert_no_violation create_validator, create_constraint(value: expected), actual
      end
    end

    INVALID_COMPARISONS.each do |(actual, expected, message)|
      it "invalid #{message}" do
        assert_violations create_validator, create_constraint(value: expected), actual
      end
    end
  end
end

def get_violation(message : String, *, invalid_value : _ = nil, root : _ = nil, property_path : String = "", code : String = "") : AVD::Violation::ConstraintViolation
  AVD::Violation::ConstraintViolation.new message, message, Hash(String, String).new, root, property_path, invalid_value, code: code
end

def create_context : AVD::ExecutionContextInterface
  AVD::ExecutionContext.new MockValidator.new, nil
end

private def validate(validator : AVD::ConstraintValidator, constraint : AVD::Constraint, value : _) : AVD::Violation::ConstraintViolationListInterface
  context = create_context

  validator.context = context

  validator.validate value, constraint

  context.violations
end

def assert_no_violation(validator : AVD::ConstraintValidator, constraint : AVD::Constraint, value : _) : Nil
  validate(validator, constraint, value).should be_empty
end

def assert_violations(validator : AVD::ConstraintValidator, constraint : AVD::Constraint, value : _, & : AVD::Violation::ConstraintViolationListInterface ->) : Nil
  violations = validate(validator, constraint, value)

  yield violations
end

def assert_violations(validator : AVD::ConstraintValidator, constraint : AVD::Constraint, value : _) : Nil
  assert_violations(validator, constraint, value) do |violations|
    violations.should_not be_empty
  end
end
