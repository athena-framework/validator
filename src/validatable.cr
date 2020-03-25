module Athena::Validator::Validatable
  macro included
    extend AVD::Validatable

    def validation_metadata : AVD::Metadata::ClassMetadata
      class_metadata = AVD::Metadata::ClassMetadata.new self.class

      {% verbatim do %}
        {% begin %}
          # Add class constraints
          {% for class_constraint in AVD::Constraint.all_subclasses.select { |c| !c.abstract? && (targets = c.constant("TARGETS")) && targets.includes? "class" } %}
            {% constraint = class_constraint %}

            {% if (ann_name = class_constraint.constant("ANNOTATION").resolve) && (class_ann = @type.annotation(ann_name)) %}
              {% supported_types = constraint.constant("VALIDATOR").resolve.methods.select { |m| m.name == "validate" && m.visibility == :public }.map { |m| m.args.first.restriction } %}
              {% raise "Constraint #{constraint} cannot be applied to #{@type}.  This constraint does not support the #{@type} type." unless supported_types.any? { |t| t.is_a?(Underscore) ? true : t.resolve >= @type.resolve } %}

              class_metadata.add_constraint {{class_constraint.id}}.new({{class_ann.named_args.double_splat}})
            {% end %}
          {% end %}

          # Add property constraints
          {% for ivar in @type.instance_vars %}
            {% for property_constraint in AVD::Constraint.all_subclasses.select { |c| !c.abstract? && (targets = c.constant("TARGETS")) && targets.includes? "property" } %}
              {% constraint = property_constraint %}
              {% ivar = ivar %}

              {% if (ann_name = property_constraint.constant("ANNOTATION").resolve) && (property_ann = ivar.annotation(ann_name)) %}
                {% supported_types = constraint.constant("VALIDATOR").resolve.methods.select { |m| m.name == "validate" && m.visibility == :public }.map { |m| m.args.first.restriction } %}
                {% raise "Constraint #{constraint} cannot be applied to #{@type}##{ivar.name}.  This constraint does not support the #{ivar.type} type." unless supported_types.any? { |t| t.is_a?(Underscore) ? true : t.resolve >= ivar.type } %}

                class_metadata.add_property_constraint(
                  AVD::Metadata::PropertyMetadata({{ivar.type}}).new(->{ @{{ivar.id}} }, {{@type}}, {{ivar.name.stringify}}),
                  {{property_constraint.id}}.new({{property_ann.named_args.double_splat}})
                )
              {% end %}
            {% end %}
          {% end %}

          # Add callback constraints
          {% for callback in @type.methods.select &.annotation(Assert::Callback) %}
            class_metadata.add_constraint AVD::Constraints::Callback.new(callback: ->{{callback.name.id}}(AVD::Constraints::Callback::Container), static: false, {{callback.annotation(Assert::Callback).named_args.double_splat}})
          {% end %}

          {% for callback in @type.class.methods.select &.annotation(Assert::Callback) %}
            class_metadata.add_constraint AVD::Constraints::Callback.new(callback: ->{{@type}}.{{callback.name.id}}(AVD::Constraints::Callback::Container), {{callback.annotation(Assert::Callback).named_args.double_splat}})
          {% end %}
        {% end %}

        class_metadata
      {% end %}
    end
  end
end
