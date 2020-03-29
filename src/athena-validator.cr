require "./constraint"
require "./constraint_validator"
require "./constraint_validator_factory"
require "./constraint_validator_factory_interface"
require "./constraint_validator_interface"
require "./execution_context"
require "./execution_context_interface"
require "./property_path"
require "./validatable"

require "./constraints/*"
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

  module Compare
    def self.gt(value1 : _, value2 : _) : Bool
      compare(value1, value2) do |cmp|
        cmp > 0
      end
    end

    def self.gte(value1 : _, value2 : _) : Bool
      compare(value1, value2) do |cmp|
        cmp >= 0
      end
    end

    def self.lt(value1 : _, value2 : _) : Bool
      compare(value1, value2) do |cmp|
        cmp < 0
      end
    end

    def self.lte(value1 : _, value2 : _) : Bool
      compare(value1, value2) do |cmp|
        cmp <= 0
      end
    end

    private def self.compare(value1 : _, value2 : _, & : Int32 -> Bool) : Bool
      return false unless cmp = (value1 <=> value2)

      yield cmp
    end
  end
end
