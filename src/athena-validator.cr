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
  VERSION = "0.1.0"

  # Default namespace for constaint annotations.
  module Annotations; end

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

# private struct Foo
#   include AVD::Validatable

#   @[Assert::Range(range: 0..10)]
#   property value : Bool = false
# end

validator = AVD.validator

# constraint = AVD::Constraints::NotBlank.new

# # range_constraint = AVD::Constraints::Range(Int32, Int32).new 0..10
# equal_to_constraint = AVD::Constraints::EqualTo.new "yes"

# puts validator.validate 17, [constraint]
# puts validator.validate "no", [equal_to_constraint]
# # puts validator.validate 5, [greater_than_constraint]
# puts validator.validate 50, [AVD::Constraints::GreaterThan.new 10.0]
# puts validator.validate 0_u8, [AVD::Constraints::GreaterThan.new 10.0]
# puts validator.validate "zzz", [AVD::Constraints::GreaterThan.new "foo"]
# puts validator.validate false, [AVD::Constraints::GreaterThan.new "foo"]

value = 11 || "foo" || nil

pp typeof(value)

constraint = AVD::Constraints::GreaterThan.new 5

puts validator.validate value, [constraint]
