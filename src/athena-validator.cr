require "./constraint"
require "./constraint_validator"
require "./constraint_validator_factory"
require "./constraint_validator_factory_interface"
require "./constraint_validator_interface"
require "./execution_context"
require "./execution_context_interface"
require "./property_path"
require "./validatable"

require "./constraints/abstract_comparison"
require "./constraints/abstract_comparison_validator"
require "./constraints/*"
require "./exceptions/*"
require "./metadata/*"
require "./validator/*"
require "./violation/*"

# Convenience alias to make referencing `Athena::Validator` types easier.
alias AVD = Athena::Validator

alias Assert = AVD::Annotations

module Athena::Validator
  # :nodoc:
  #
  # Default namespace for constaint annotations.
  module Annotations
    {% for constraint in AVD::Constraint.all_subclasses.reject &.abstract? %}
      annotation {{constraint.name(generic_args: false).split("::").last.id}}; end
    {% end %}
  end

  # :nodoc:
  abstract struct Container; end

  # :nodoc:
  record ValueContainer(T) < Container, value : T do
    def value_type : T.class
      T
    end

    def ==(other : self) : Bool
      @value == other.value
    end
  end

  def self.validator(validator_factory : AVD::ConstraintValidatorFactoryInterface? = nil) : AVD::Validator::ValidatorInterface
    AVD::Validator::RecursiveValidator.new validator_factory
  end
end

validator = AVD.validator

struct Foo
  include AVD::Validatable

  @[Assert::Callback]
  def self.validate(object : AVD::Constraints::Callback::Value, context : AVD::ExecutionContextInterface, payload : Hash(String, String)?) : Nil
    context.build_violation("Invalid name").at_path("name").add
  end

  def initialize(@value : Int32, @name : String); end

  @[Assert::Negative]
  property value : Int32

  @[Assert::NotBlank]
  property name : String

  @[Assert::Callback]
  def validate(context : AVD::ExecutionContextInterface, payload : Hash(String, String)?) : Nil
    context.build_violation("bad ID").at_path("value").add
  end
end

constraint = AVD::Constraints::Callback.with_callback do |value, context, payload|
  pp value.value == "foo"
  pp value == "foo"
end

validator.validate "foo", [constraint]

# obj = Foo.new 50, ""

# puts validator.validate obj
# Object(Foo).value:
#   This value should be between 0 and 10. (code: 7e62386d-30ae-4e7c-918f-1b7e571c6d69)
# Object(Foo).name:
#   This value should not be blank. (code: 0d0c3254-3642-4cb0-9882-46ee5918e6e3)

# constraint = AVD::Constraints::NotBlank.new

# range_constraint = AVD::Constraints::Range(Int32, Int32).new 0..10
# equal_to_constraint = AVD::Constraints::EqualTo.new "yes"

# puts validator.validate 12, [range_constraint]
# puts validator.validate 5, [range_constraint]
# puts validator.validate false, [range_constraint]

# puts validator.validate 17, [constraint]
# puts validator.validate "no", [equal_to_constraint]
# puts validator.validate 50, [AVD::Constraints::GreaterThan.new 10.0]
# puts validator.validate 0_u8, [AVD::Constraints::GreaterThan.new 10.0]
# puts validator.validate "zzz", [AVD::Constraints::GreaterThan.new "foo"]
# puts validator.validate false, [AVD::Constraints::GreaterThan.new "foo"]

# value = 11 || "foo" || nil

# constraint = AVD::Constraints::Positive.new

# puts validator.validate 10, [constraint]
# puts validator.validate Int64::MAX - 1, [constraint]
# puts validator.validate 0, [constraint]
# puts validator.validate -5, [constraint]
