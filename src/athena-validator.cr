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

class Address
  include AVD::Validatable

  def initialize(@street : String, @zip_code : String); end

  @[Assert::NotBlank]
  @street : String

  @[Assert::NotBlank]
  @[Assert::Size(..5)]
  @zip_code : String
end

class Author
  include AVD::Validatable

  def initialize(@first_name : String, @last_name : String, @address : Address); end

  @[Assert::NotBlank]
  @first_name : String

  @[Assert::NotBlank]
  @[Assert::Size(4..)]
  @last_name : String

  @[Assert::Valid]
  @address : Address
end

address = Address.new "", "15061"
author = Author.new "Jim", "Bobb", address

validator = AVD.validator

pp validator.validate author
# Object(Author).address.street:
#   This value should not be blank. (code: 0d0c3254-3642-4cb0-9882-46ee5918e6e3)

