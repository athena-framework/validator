require "./constraint_validator_factory_interface"

struct Athena::Validator::ConstraintValidatorFactory
  include Athena::Validator::ConstraintValidatorFactoryInterface

  @validators : Hash(AVD::ConstraintValidator.class, AVD::ConstraintValidator) = Hash(AVD::ConstraintValidator.class, AVD::ConstraintValidator).new

  macro finished
    {% begin %}
      {% for constraint in Athena::Validator::Constraint.all_subclasses.reject &.abstract? %}
        {% validator = constraint.annotation(AVD::RegisterConstraint)[:validator].id %}

        # :inherit:
        def validator(constraint : {{constraint.id}}) : {{validator}}{% unless constraint.type_vars.empty? %} forall {{constraint.type_vars.splat}}{% end %}
          validator_class = constraint.class.validator

          @validators[validator_class] = validator_class.new unless @validators.has_key? validator_class

          @validators[validator_class].as({{validator}})
        end
      {% end %}
    {% end %}
  end
end
