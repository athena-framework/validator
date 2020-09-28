require "athena-spec"

module Athena::Validator::Spec
  # Test case designed to make testing `AVD::ConstraintViolationInterface` easier.
  abstract struct ConstraintValidatorTestCase < ASPEC::TestCase
    @group : String
    @metadata : Nil = nil
    @object : Nil = nil
    @value : String
    @root : String
    @property_path : String

    @constraint : AVD::Constraint

    # :nodoc:
    getter! context : AVD::ExecutionContext(String)

    # :nodoc:
    getter! validator : AVD::ConstraintValidatorInterface

    def initialize
      @group = "my_group"
      @value = "invalid_value"
      @root = "root"
      @property_path = "property.path"

      @constraint = AVD::Constraints::NotBlank.new

      context = self.create_context
      validator = self.create_validator
      validator.context = context

      @context = context
      @validator = validator
    end

    abstract def create_validator : AVD::ConstraintValidatorInterface
    abstract def constraint_class : AVD::Constraint.class

    def new_constraint(**args)
      self.constraint_class.new **args
    end

    def assert_no_violation(*, file : String = __FILE__, line : Int32 = __LINE__) : Nil
      unless (violation_count = self.context.violations.size).zero?
        fail "0 violations expected but got #{violation_count}.", file, line
      end
    end

    def build_violation(message : String) : ConstraintViolationAssertion
      ConstraintViolationAssertion.new self.context, message, @constraint
    end

    def build_violation(message : String, code : String) : ConstraintViolationAssertion
      self.build_violation(message).code(code)
    end

    def build_violation(message : String, code : String, value : _) : ConstraintViolationAssertion
      self.build_violation(message).code(code).add_parameter("{{ value }}", value)
    end

    private def create_context : AVD::ExecutionContext
      validator = MockValidator.new

      context = AVD::ExecutionContext.new validator, @root
      context.group = @group
      context.set_node @value, @object, @metadata, @property_path
      context.constraint = @constraint

      context
    end
  end

  abstract struct AbstractComparisonValidatorTestCase < ConstraintValidatorTestCase
    abstract def valid_comparisons
    abstract def invalid_comparisons
    abstract def error_code : String

    @[DataProvider("valid_comparisons")]
    def test_valid_comparisons(actual, expected) : Nil
      constraint = new_constraint value: expected

      self.validator.validate actual, constraint
      self.assert_no_violation
    end

    @[DataProvider("invalid_comparisons")]
    def test_invalid_comparisons(actual, expected : T) : Nil forall T
      constraint = new_constraint value: expected, message: "my_message"

      self.validator.validate actual, constraint

      self.build_violation("my_message")
        .add_parameter("{{ value }}", actual)
        .add_parameter("{{ compared_value }}", expected)
        .add_parameter("{{ compared_value_type }}", T)
        .code(self.error_code)
        .assert_violation
    end
  end

  struct MockContextualValidator
    include Athena::Validator::Validator::ContextualValidatorInterface

    def at_path(path : String) : AVD::Validator::ContextualValidatorInterface
      self
    end

    def validate(value : _, constraints : Array(AVD::Constraint) | AVD::Constraint | Nil = nil, groups : Array(String) | String | Nil = nil) : AVD::Validator::ContextualValidatorInterface
      self
    end

    def validate_property(object : AVD::Validatable, property_name : String, groups : Array(String) | String | Nil = nil) : AVD::Validator::ContextualValidatorInterface
      self
    end

    def validate_property_value(object : AVD::Validatable, property_name : String, value : _, groups : Array(String) | String | Nil = nil) : AVD::Validator::ContextualValidatorInterface
      self
    end

    def violations : AVD::Violation::ConstraintViolationListInterface
      AVD::Violation::ConstraintViolationList.new
    end
  end

  struct MockValidator
    include Athena::Validator::Validator::ValidatorInterface

    def validate(value : _, constraints : Array(AVD::Constraint) | AVD::Constraint | Nil = nil, groups : Array(String) | String | Nil = nil) : AVD::Violation::ConstraintViolationListInterface
      AVD::Violation::ConstraintViolationList.new
    end

    def validate_property(object : AVD::Validatable, property_name : String, groups : Array(String) | String | Nil = nil) : AVD::Violation::ConstraintViolationListInterface
      AVD::Violation::ConstraintViolationList.new
    end

    def validate_property_value(object : AVD::Validatable, property_name : String, value : _, groups : Array(String) | String | Nil = nil) : AVD::Violation::ConstraintViolationListInterface
      AVD::Violation::ConstraintViolationList.new
    end

    def start_context(root = nil) : AVD::Validator::ContextualValidatorInterface
      MockContextualValidator.new
    end

    def in_context(context : AVD::ExecutionContextInterface) : AVD::Validator::ContextualValidatorInterface
      MockContextualValidator.new
    end
  end

  record ConstraintViolationAssertion, context : AVD::ExecutionContextInterface, message : String, constraint : AVD::Constraint do
    @parameters : Hash(String, String) = Hash(String, String).new
    @invalid_value : AVD::Container = AVD::ValueContainer.new("invalid_value")
    @property_path : String = "property.path"
    @plural : Int32? = nil
    @code : String? = nil
    @cause : String? = nil

    def at_path(@property_path : String) : self
      self
    end

    def add_parameter(key : String, value : _) : self
      @parameters[key] = value.to_s

      self
    end

    def build_violation(@message : String) : self
      self
    end

    def invalid_value(value : _) : self
      @invalid_value = AVD::ValueContainer.new value

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

    def assert_violation(*, file : String = __FILE__, line : Int32 = __LINE__) : Nil
      expected_violations = [self.get_violation] of AVD::Violation::ConstraintViolationInterface

      violations = @context.violations

      violations.size.should eq 1

      expected_violations.each_with_index do |violation, idx|
        violation.should eq(violations[idx]), file: file, line: line
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
end
