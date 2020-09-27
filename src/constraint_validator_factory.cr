require "./constraint_validator_factory_interface"

struct Athena::Validator::ConstraintValidatorFactory
  include Athena::Validator::ConstraintValidatorFactoryInterface

  @validators : Hash(AVD::ConstraintValidator.class, AVD::ConstraintValidator) = Hash(AVD::ConstraintValidator.class, AVD::ConstraintValidator).new

  macro finished
    {% for validator in Athena::Validator::ConstraintValidator::Basic.includers %}
      def validator(validator_class : {{validator.id}}.class) : AVD::ConstraintValidator
        if validator = @validators[validator_class]?
          return validator
        end

        @validators[validator_class] = {{validator.id}}.new
      end
    {% end %}
  end

  def validator(validator_class : AVD::ConstraintValidator.class) : AVD::ConstraintValidator
    @validators[validator_class]
  end
end
