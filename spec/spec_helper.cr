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

macro define_comparison_spec(with_value = true)
  describe "#validate" do
    VALID_COMPARISONS.each do |(actual, expected, message)|
      it "valid #{message}" do
        assert_constraint_validator create_validator, create_constraint{% if with_value %}(value: expected){% end %} do
          validate actual

          assert_no_violations
        end
      end
    end

    INVALID_COMPARISONS.each do |(actual, expected, message)|
      it "invalid #{message}" do
        assert_constraint_validator create_validator, create_constraint(message: "message"{% if with_value %}, value: expected{% end %}) do
          validate actual

          build_violation("message")
            .add_parameter("\{{ value }}", actual)
            .add_parameter("\{{ compared_value }}", expected)
            .add_parameter("\{{ compared_value_type }}", typeof(expected))
            .code(error_code)
            .assert_violation
        end
      end
    end
  end
end

def get_violation(message : String, *, invalid_value : _ = nil, root : _ = nil, property_path : String = "", code : String = "") : AVD::Violation::ConstraintViolation
  AVD::Violation::ConstraintViolation.new message, message, Hash(String, String).new, root, property_path, invalid_value, code: code
end

def assert_constraint_validator(validator : AVD::ConstraintValidator, constraint : AVD::Constraint, group : String? = nil, &)
  context = AVD::ExecutionContext.new MockValidator.new, nil
  context.group = group
  context.set_node "invalid_value", nil, nil, "property_path"
  context.constraint = constraint

  validator.context = context

  assertion = ConstraintViolationAssertion.new context, validator, constraint

  with assertion yield
end

record ConstraintViolationAssertion, context : AVD::ExecutionContextInterface, validator : AVD::ConstraintValidator, constraint : AVD::Constraint do
  @message : String = "message"
  @parameters : Hash(String, String) = Hash(String, String).new
  @invalid_value : String = "invalid_value"
  @property_path : String = "property_path"
  @plural : Int32? = nil
  @code : String? = nil
  @cause : String? = nil

  def assert_no_violations : Nil
    @context.violations.should be_empty
  end

  def validate(value : _) : Nil
    @validator.validate value, @constraint
  end

  def add_parameter(key : String, value : _) : self
    @parameters[key] = value.to_s

    self
  end

  def build_violation(@message : String) : self
    self
  end

  def plural(@plural : Int32) : self
    self
  end

  def code(@code : String?) : self
    self
  end

  def cause(@cause : String?) : self
    self
  end

  def assert_violation : Nil
    expected_violations = [self.get_violation] of AVD::Violation::ConstraintViolationInterface

    violations = @context.violations

    violations.size.should eq 1

    expected_violations.each_with_index do |violation, idx|
      violation.should eq violations[idx]
    end
  end

  private def get_violation
    AVD::Violation::ConstraintViolation.new(
      @message,
      @message,
      @parameters,
      @context.root,
      @property_path,
      @invalid_value,
      @plural,
      @code,
      @constraint,
      @cause
    )
  end
end
