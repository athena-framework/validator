require "./constraint"
require "./execution_context_interface"
require "./execution_context"
require "./constraint_validator_factory_interface"
require "./constraint_validator_factory"
require "./constraint_validator_interface"
require "./constraint_validator"

require "./constraints/*"
require "./metadata/*"
require "./validator/*"
require "./violation/*"

# Convenience alias to make referencing `Athena::Validator` types easier.
alias AVD = Athena::Validator

alias Assert = AVD::Annotations

module Athena::Validator
  VERSION = "0.1.0"

  module Validatable
    macro included
      extend AVD::Validatable

      def validation_metadata : AVD::Metadata::Class
        class_metadata = AVD::Metadata::Class.new self.class

        {% verbatim do %}
          {% begin %}
            {% for class_constraint in AVD::Constraint.all_subclasses.select { |c| !c.abstract? && (targets = c.constant("TARGETS")) && targets.includes? "class" } %}
              {% constraint = class_constraint %}

              {% if (ann_name = class_constraint.constant("ANNOTATION").resolve) && (class_ann = @type.annotation(ann_name)) %}
                {% supported_types = constraint.constant("VALIDATOR").resolve.methods.select { |m| m.name == "validate" && m.visibility == :public }.map { |m| m.args.first.restriction } %}
                {% raise "Constraint #{constraint} cannot be applied to #{@type}.  This constraint does not support the #{@type} type." unless supported_types.any? { |t| t.is_a?(Underscore) ? true : t.resolve >= @type.resolve } %}

                class_metadata.add_constraint {{class_constraint.id}}.new({{class_ann.named_args.double_splat}})
              {% end %}
            {% end %}

            {% for ivar in @type.instance_vars %}
              {% for property_constraint in AVD::Constraint.all_subclasses.select { |c| !c.abstract? && (targets = c.constant("TARGETS")) && targets.includes? "property" } %}
                {% constraint = property_constraint %}
                {% ivar = ivar %}

                {% if (ann_name = property_constraint.constant("ANNOTATION").resolve) && (property_ann = ivar.annotation(ann_name)) %}
                  {% supported_types = constraint.constant("VALIDATOR").resolve.methods.select { |m| m.name == "validate" && m.visibility == :public }.map { |m| m.args.first.restriction } %}
                  {% raise "Constraint #{constraint} cannot be applied to #{@type}##{ivar.name}.  This constraint does not support the #{ivar.type} type." unless supported_types.any? { |t| t.is_a?(Underscore) ? true : t.resolve >= ivar.type } %}

                  class_metadata.add_property_constraint(
                    AVD::Metadata::Property({{ivar.type}}).new(->{ @{{ivar.id}} }, {{@type}}, {{ivar.name.stringify}}),
                    {{property_constraint.id}}.new({{property_ann.named_args.double_splat}})
                  )
                {% end %}
              {% end %}
            {% end %}
          {% end %}

          class_metadata
        {% end %}
      end
    end
  end

  module Annotations
  end

  # :nodoc:
  abstract struct Container; end

  # :nodoc:
  record ValueContainer(T) < Container, value : T

  module PropertyPath
    def self.append(base_path : String, sub_path : String) : String
      return base_path if sub_path.blank?

      return "#{base_path}#{sub_path}" if sub_path.starts_with? '['

      !base_path.blank? ? "#{base_path}.#{sub_path}" : sub_path
    end
  end
end
