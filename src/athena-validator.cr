require "json"

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

# Used to apply constraints to instance variables and types via annotations.
#
# ```
# @[Assert::NotBlank]
# property name : String
# ```
alias Assert = AVD::Annotations

# Athena's Validation component, `AVD` for short, adds an object/value validation framework to your project.
module Athena::Validator
  # :nodoc:
  #
  # Default namespace for constraint annotations.
  #
  # NOTE: Constraints are automatically added to this namespace.
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
