require "athena-spec"
require "./spec/abstract_validator_test_case"
require "./spec/validator_test_case"

# A set of testing utilities/types to aid in testing `AVD` related types.
# The main things to note include:
#
# * `AVD::Spec::ConstraintValidatorTestCase` - An [ASPEC::Test](https://athena-framework.github.io/spec/Athena/Spec/TestCase.html) extension
# for testing `AVD::ConstraintValidatorInterface`s.
# * `AVD::Spec::AbstractComparisonValidatorTestCase` - An `AVD::Spec::ConstraintValidatorTestCase` extension for testing
# `AVD::Constraints::AbstractComparison` based constraints.
# * `AVD::Spec::ConstraintViolationAssertion` - Similar to `AVD::Violation::ConstraintViolationBuilder` but
# for asserting the violation added to the context was built as expected.
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

    getter! context : AVD::ExecutionContext(String)

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

    # Responsible for returning a new validator instance for the constraint being tested.
    abstract def create_validator : AVD::ConstraintValidatorInterface

    # Returns the class of the constraint being tested.
    abstract def constraint_class : AVD::Constraint.class

    # Returns a new constraint instance based on `#constraint_class` and the provided *args*.
    def new_constraint(**args) : AVD::Constraint
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
      self.validator.validate actual, self.new_constraint value: expected
      self.assert_no_violation
    end

    @[DataProvider("invalid_comparisons")]
    def test_invalid_comparisons(actual, expected : T) : Nil forall T
      self.validator.validate actual, self.new_constraint value: expected, message: "my_message"

      self
        .build_violation("my_message", self.error_code, actual)
        .add_parameter("{{ compared_value }}", expected)
        .add_parameter("{{ compared_value_type }}", T)
        .assert_violation
    end
  end

  # A spec implementation of `AVD::Validator::ContextualValidatorInterface`.
  struct MockContextualValidator
    include Athena::Validator::Validator::ContextualValidatorInterface

    def at_path(path : String) : AVD::Validator::ContextualValidatorInterface
      self
    end

    def validate(value : _, constraints : Array(AVD::Constraint) | AVD::Constraint | Nil = nil, groups : Array(String) | String | AVD::Constraints::GroupSequence | Nil = nil) : AVD::Validator::ContextualValidatorInterface
      self
    end

    def validate_property(object : AVD::Validatable, property_name : String, groups : Array(String) | String | AVD::Constraints::GroupSequence | Nil = nil) : AVD::Validator::ContextualValidatorInterface
      self
    end

    def validate_property_value(object : AVD::Validatable, property_name : String, value : _, groups : Array(String) | String | AVD::Constraints::GroupSequence | Nil = nil) : AVD::Validator::ContextualValidatorInterface
      self
    end

    def violations : AVD::Violation::ConstraintViolationListInterface
      AVD::Violation::ConstraintViolationList.new
    end
  end

  # A spec implementation of `AVD::Validator::ValidatorInterface`.
  struct MockValidator
    include Athena::Validator::Validator::ValidatorInterface

    def validate(value : _, constraints : Array(AVD::Constraint) | AVD::Constraint | Nil = nil, groups : Array(String) | String | AVD::Constraints::GroupSequence | Nil = nil) : AVD::Violation::ConstraintViolationListInterface
      AVD::Violation::ConstraintViolationList.new
    end

    def validate_property(object : AVD::Validatable, property_name : String, groups : Array(String) | String | AVD::Constraints::GroupSequence | Nil = nil) : AVD::Violation::ConstraintViolationListInterface
      AVD::Violation::ConstraintViolationList.new
    end

    def validate_property_value(object : AVD::Validatable, property_name : String, value : _, groups : Array(String) | String | AVD::Constraints::GroupSequence | Nil = nil) : AVD::Violation::ConstraintViolationListInterface
      AVD::Violation::ConstraintViolationList.new
    end

    def start_context(root = nil) : AVD::Validator::ContextualValidatorInterface
      MockContextualValidator.new
    end

    def in_context(context : AVD::ExecutionContextInterface) : AVD::Validator::ContextualValidatorInterface
      MockContextualValidator.new
    end
  end

  # A spec implementation of `AVD::Metadata::MetadataFactoryInterface`.
  struct MockMetadataFactory(T1, T2, T3, T4)
    include AVD::Metadata::MetadataFactoryInterface

    @metadatas = Hash(AVD::Validatable::Class, AVD::Metadata::ClassMetadata(T1) |
                                               AVD::Metadata::ClassMetadata(T2) |
                                               AVD::Metadata::ClassMetadata(T3) |
                                               AVD::Metadata::ClassMetadata(T4)).new

    def metadata(object : AVD::Validatable) : AVD::Metadata::ClassMetadata
      if metadata = @metadatas[object.class]?
        return metadata
      end

      object.class.validation_class_metadata
    end

    def add_metadata(klass : AVD::Validatable::Class, metadata : AVD::Metadata::ClassMetadata) : Nil
      @metadatas[klass] = metadata
    end
  end

  record EntitySequenceProvider, sequence : Array(String | Array(String)) do
    include AVD::Validatable
    include AVD::Constraints::GroupSequence::Provider

    def group_sequence : Array(String | Array(String)) | AVD::Constraints::GroupSequence
      @sequence || AVD::Constraints::GroupSequence.new [] of String
    end
  end

  record EntityGroupSequenceProvider, sequence : AVD::Constraints::GroupSequence do
    include AVD::Validatable
    include AVD::Constraints::GroupSequence::Provider

    def group_sequence : Array(String | Array(String)) | AVD::Constraints::GroupSequence
      @sequence || Array(String | Array(String)).new
    end
  end

  # An `AVD::Violation::ConstraintViolation` used to assert that a violation added via an `AVD::ConstraintValidatorInterface` was built as expected.
  #
  # This type should not be used directly, use `AVD::Spec::ConstraintValidatorTestCase#build_violation` instead.
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
