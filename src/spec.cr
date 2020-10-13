require "athena-spec"
require "./spec/abstract_validator_test_case"
require "./spec/validator_test_case"

# A set of testing utilities/types to aid in testing `Athena::Validator` related types.
#
# ### Getting Started
#
# Require this module in your `spec_helper.cr` file.
#
# ```
# # This also requires "spec" and "athena-spec".
# require "athena-validator/spec"
# ```
#
# Add `Athena::Spec` as a development dependency, then run a `shards install`.
# See the individual types for more information.
module Athena::Validator::Spec
  # Test case designed to make testing `AVD::ConstraintValidatorInterface` easier.
  #
  # ### Example
  #
  # Using the spec from `AVD::Constraints::NotNull`:
  #
  # ```
  # # Makes for a bit less typing when needing to reference the constraint.
  # private alias CONSTRAINT = AVD::Constraints::NotNull
  #
  # # Define our test case inheriting from the abstract ConstraintValidatorTestCase.
  # struct NotNullValidatorTest < AVD::Spec::ConstraintValidatorTestCase
  #   @[DataProvider("valid_values")]
  #   def test_valid_values(value : _) : Nil
  #     # Validate the value against a new instance of the constraint.
  #     self.validator.validate value, self.new_constraint
  #
  #     # Assert no violations were added to the context.
  #     self.assert_no_violation
  #   end
  #
  #   # Use data providers to reduce duplication.
  #   def valid_values : NamedTuple
  #     {
  #       string:       {""},
  #       bool_false:   {false},
  #       bool_true:    {true},
  #       zero:         {0},
  #       null_pointer: {Pointer(Void).null},
  #     }
  #   end
  #
  #   def test_nil_is_invalid
  #     # Validate an invalid value against a new instance of the constraint with a custom message.
  #     self.validator.validate nil, self.new_constraint message: "my_message"
  #
  #     # Asssert a violation with the expected message, code, and value parameter is added to the context.
  #     self
  #       .build_violation("my_message", CONSTRAINT::IS_NULL_ERROR, nil)
  #       .assert_violation
  #   end
  #
  #   # Implement some abstract defs to return the validator and constraint class.
  #   private def create_validator : AVD::ConstraintValidatorInterface
  #     CONSTRAINT::Validator.new
  #   end
  #
  #   private def constraint_class : AVD::Constraint.class
  #     CONSTRAINT
  #   end
  # end
  # ```
  #
  # This type is an extension of `ASPEC::TestCase`, see that type for more information on this testing approach.
  # This approach also allows using `ASPEC::TestCase::DataProvider`s for reducing duplication withing your test.
  abstract struct ConstraintValidatorTestCase < ASPEC::TestCase
    # Used to assert that a violation added via the `AVD::ConstraintValidatorInterface` was built as expected.
    #
    # NOTE: This type should not be instantiated directly, use `AVD::Spec::ConstraintValidatorTestCase#build_violation` instead.
    record Assertion, context : AVD::ExecutionContextInterface, message : String, constraint : AVD::Constraint do
      @parameters : Hash(String, String) = Hash(String, String).new
      @invalid_value : AVD::Container = AVD::ValueContainer.new("invalid_value")
      @property_path : String = "property.path"
      @plural : Int32? = nil
      @code : String? = nil
      @cause : String? = nil

      # Sets the `AVD::Violation::ConstraintViolationInterface#property_path` on the expected violation.
      #
      # Returns `self` for chaining.
      def at_path(@property_path : String) : self
        self
      end

      # Adds the provided *key* *value* pair to the expected violations' `AVD::Violation::ConstraintViolationInterface#parameters`.
      #
      # Returns `self` for chaining.
      def add_parameter(key : String, value : _) : self
        @parameters[key] = value.to_s

        self
      end

      # Sets the `AVD::Violation::ConstraintViolationInterface#invalid_value` on the expected violation.
      #
      # Returns `self` for chaining.
      def invalid_value(value : _) : self
        @invalid_value = AVD::ValueContainer.new value

        self
      end

      # Sets the `AVD::Violation::ConstraintViolationInterface#plural` on the expected violation.
      #
      # Returns `self` for chaining.
      def plural(@plural : Int32) : self
        self
      end

      # Sets the `AVD::Violation::ConstraintViolationInterface#code` on the expected violation.
      #
      # Returns `self` for chaining.
      def code(@code : String?) : self
        self
      end

      # Sets the `AVD::Violation::ConstraintViolationInterface#cause` on the expected violation.
      #
      # Returns `self` for chaining.
      def cause(@cause : String?) : self
        self
      end

      # Asserts that the violation added to the context equals the violation built via `self`.
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

    @group : String
    @metadata : Nil = nil
    @object : Nil = nil
    @value : String
    @root : String
    @property_path : String
    @constraint : AVD::Constraint
    @context : AVD::ExecutionContext(String)?
    @validator : AVD::ConstraintValidatorInterface?

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

    # Returns a new validator instance for the constraint being tested.
    abstract def create_validator : AVD::ConstraintValidatorInterface

    # Returns the class of the constraint being tested.
    abstract def constraint_class : AVD::Constraint.class

    # Returns a new constraint instance based on `#constraint_class` and the provided *args*.
    def new_constraint(**args) : AVD::Constraint
      self.constraint_class.new **args
    end

    # Asserts that no violations were added to the context.
    def assert_no_violation(*, file : String = __FILE__, line : Int32 = __LINE__) : Nil
      unless (violation_count = self.context.violations.size).zero?
        fail "0 violations expected but got #{violation_count}.", file, line
      end
    end

    # Asserts a violation with the provided *message* was added to the context.
    def assert_violation(message : String) : Nil
      self.build_violation(message).assert_violation
    end

    # Asserts a violation with the provided provided *message*, and *code* was added to the context.
    def assert_violation(message : String, code : String) : Nil
      self.build_violation(message, code).assert_violation
    end

    # Asserts a violation with the provided *message*, *code*, and *value* parameter was added to the context.
    def assert_violation(message : String, code : String, value : _) : Nil
      self.build_violation(message, code, value).assert_violation
    end

    # Returns an `AVD::Spec::ConstraintValidatorTestCase::Assertion` with the provided *message* preset.
    def build_violation(message : String) : AVD::Spec::ConstraintValidatorTestCase::Assertion
      Assertion.new self.context, message, @constraint
    end

    # Returns an `AVD::Spec::ConstraintValidatorTestCase::Assertion` with the provided *message*, and *code* preset.
    def build_violation(message : String, code : String) : AVD::Spec::ConstraintValidatorTestCase::Assertion
      self.build_violation(message).code(code)
    end

    # Returns an `AVD::Spec::ConstraintValidatorTestCase::Assertion` with the provided *message*, *code*, and *value* parameter preset.
    def build_violation(message : String, code : String, value : _) : AVD::Spec::ConstraintValidatorTestCase::Assertion
      self.build_violation(message).code(code).add_parameter("{{ value }}", value)
    end

    # Returns a reference to the context used for the current test.
    def context : AVD::ExecutionContext(String)
      @context.not_nil!
    end

    # Returns the validator instance returned via `#create_validator`.
    def validator : AVD::ConstraintValidatorInterface
      @validator.not_nil!
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

  # Extension of `AVD::Spec::ConstraintValidatorTestCase` used for testing `AVD::Constraints::AbstractComparison` based constraints.
  #
  # ### Example
  #
  # Using the spec from `AVD::Constraints::EqualTo`:
  #
  # ```
  # # Makes for a bit less typing when needing to reference the constraint.
  # private alias CONSTRAINT = AVD::Constraints::EqualTo
  #
  # # Define our test case inheriting from the abstract AbstractComparisonValidatorTestCase.
  # struct EqualToValidatorTest < AVD::Spec::AbstractComparisonValidatorTestCase
  #   # Returns a Tuple of Tuples representing valid comparisons.
  #   # The first item  is the actual value and the second item is the expected value.
  #   def valid_comparisons : Tuple
  #     {
  #       {3, 3},
  #       {'a', 'a'},
  #       {"a", "a"},
  #       {Time.utc(2020, 4, 7), Time.utc(2020, 4, 7)},
  #       {nil, false},
  #     }
  #   end
  #
  #   # Returns a Tuple of Tuples representing invalid comparisons.
  #   # The first item  is the actual value and the second item is the expected value.
  #   def invalid_comparisons : Tuple
  #     {
  #       {1, 3},
  #       {'b', 'a'},
  #       {"b", "a"},
  #       {Time.utc(2020, 4, 8), Time.utc(2020, 4, 7)},
  #     }
  #   end
  #
  #   # The error code related to the current CONSTRAINT.
  #   def error_code : String
  #     CONSTRAINT::NOT_EQUAL_ERROR
  #   end
  #
  #   # Implement some abstract defs to return the validator and constraint class.
  #   def create_validator : AVD::ConstraintValidatorInterface
  #     CONSTRAINT::Validator.new
  #   end
  #
  #   def constraint_class : AVD::Constraint.class
  #     CONSTRAINT
  #   end
  # end
  # ```
  abstract struct AbstractComparisonValidatorTestCase < ConstraintValidatorTestCase
    # A `Tuple` of tuples representing valid comparisons.
    abstract def valid_comparisons : Tuple

    # A `Tuple` of tuples representing invalid comparisons.
    abstract def invalid_comparisons : Tuple

    # The code for the current constraint.
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

    # :inherit:
    def at_path(path : String) : AVD::Validator::ContextualValidatorInterface
      self
    end

    # :inherit:
    def validate(value : _, constraints : Array(AVD::Constraint) | AVD::Constraint | Nil = nil, groups : Array(String) | String | AVD::Constraints::GroupSequence | Nil = nil) : AVD::Validator::ContextualValidatorInterface
      self
    end

    # :inherit:
    def validate_property(object : AVD::Validatable, property_name : String, groups : Array(String) | String | AVD::Constraints::GroupSequence | Nil = nil) : AVD::Validator::ContextualValidatorInterface
      self
    end

    # :inherit:
    def validate_property_value(object : AVD::Validatable, property_name : String, value : _, groups : Array(String) | String | AVD::Constraints::GroupSequence | Nil = nil) : AVD::Validator::ContextualValidatorInterface
      self
    end

    # :inherit:
    def violations : AVD::Violation::ConstraintViolationListInterface
      AVD::Violation::ConstraintViolationList.new
    end
  end

  # A spec implementation of `AVD::Validator::ValidatorInterface`.
  struct MockValidator
    include Athena::Validator::Validator::ValidatorInterface

    # :inherit:
    def validate(value : _, constraints : Array(AVD::Constraint) | AVD::Constraint | Nil = nil, groups : Array(String) | String | AVD::Constraints::GroupSequence | Nil = nil) : AVD::Violation::ConstraintViolationListInterface
      AVD::Violation::ConstraintViolationList.new
    end

    # :inherit:
    def validate_property(object : AVD::Validatable, property_name : String, groups : Array(String) | String | AVD::Constraints::GroupSequence | Nil = nil) : AVD::Violation::ConstraintViolationListInterface
      AVD::Violation::ConstraintViolationList.new
    end

    # :inherit:
    def validate_property_value(object : AVD::Validatable, property_name : String, value : _, groups : Array(String) | String | AVD::Constraints::GroupSequence | Nil = nil) : AVD::Violation::ConstraintViolationListInterface
      AVD::Violation::ConstraintViolationList.new
    end

    # :inherit:
    def start_context(root = nil) : AVD::Validator::ContextualValidatorInterface
      MockContextualValidator.new
    end

    # :inherit:
    def in_context(context : AVD::ExecutionContextInterface) : AVD::Validator::ContextualValidatorInterface
      MockContextualValidator.new
    end
  end

  # A spec implementation of `AVD::Metadata::MetadataFactoryInterface`, supporting a fixed number of additional metadatas
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

  # A constraint that always adds a violation.
  class FailingConstraint < AVD::Constraint
    def initialize(
      message : String = "Failed",
      groups : Array(String) | String | Nil = nil,
      payload : Hash(String, String)? = nil
    )
      super message, groups, payload
    end

    struct Validator < AVD::ConstraintValidator
      def validate(value : _, constraint : FailingConstraint) : Nil
        self.context.add_violation constraint.message
      end
    end
  end

  # An `AVD::Validatable` entity using an `Array` based group sequence.
  record EntitySequenceProvider, sequence : Array(String | Array(String)) do
    include AVD::Validatable
    include AVD::Constraints::GroupSequence::Provider

    def group_sequence : Array(String | Array(String)) | AVD::Constraints::GroupSequence
      @sequence || AVD::Constraints::GroupSequence.new [] of String
    end
  end

  # An `AVD::Validatable` entity using an `AVD::Constraints::GroupSequence` based group sequence.
  record EntityGroupSequenceProvider, sequence : AVD::Constraints::GroupSequence do
    include AVD::Validatable
    include AVD::Constraints::GroupSequence::Provider

    def group_sequence : Array(String | Array(String)) | AVD::Constraints::GroupSequence
      @sequence || Array(String | Array(String)).new
    end
  end
end
