require "./constraint"
require "./execution_context_interface"
require "./execution_context"
require "./constraint_validator_factory_interface"
require "./constraint_validator_factory"
require "./constraint_validator_interface"
require "./constraint_validator"

require "./metadata/*"

require "./validator/validator_interface"
require "./validator/contextual_validator_interface"
require "./validator/recursive_validator"
require "./validator/recursive_contextual_validator"

require "./constraints/*"
require "./violation/*"

# Convenience alias to make referencing `Athena::Validator` types easier.
alias AVD = Athena::Validator

module Athena::Validator
  VERSION = "0.1.0"

  module Validatable; end

  # :nodoc:
  abstract struct Container; end

  # :nodoc:
  record ValueContainer(T) < Container, value : T

  module PropertyPath
    def self.append(base_path : String, sub_path : String) : String
      return base_path if sub_path.blank?

      return "#{base_path}.#{sub_path}" if sub_path.starts_with? '['

      !base_path.blank? ? "#{base_path}.#{sub_path}" : sub_path
    end
  end
end

validator = AVD::Validator::RecursiveValidator.new

class User
  extend AVD::Validatable
  include AVD::Validatable
  @@validation_metadata : AVD::Metadata::ClassMetadata? = nil

  def validation_metadata : AVD::Metadata::ClassMetadata
    if (value = @@validation_metadata).nil?
      class_metadata = AVD::Metadata::ClassMetadata.new self.class

      class_metadata.add_property_constraint(
        AVD::Metadata::PropertyMetadata(String).new(->{ @name }, User, "name"),
        AVD::Constraints::NotBlank.new
      )

      @@validation_metadata = class_metadata
    end

    @@validation_metadata.not_nil!
  end

  property name : String

  def initialize(@name : String); end
end

# obj = User.new("")
# pp validator.validate obj

# pp pr.validation_metadata

# pp pr.validation_metadata.property_metadata("name").value
# pr.name = "Jim"
# pp pr.validation_metadata.property_metadata("name").value

# value = ""
value = false
obj = User.new ""

# pp validator.validate value, [AVD::Constraints::NotBlank.new(message: "The value '{{ value }}' should not be blank")]

# obj.name = "Jim"

pp validator.validate obj

# pp validator.validate false, [NotBlankConstraint.new]

# pp validator.validate [obj, obj]
