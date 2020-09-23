require "./generic_metadata"
require "./class_metadata_interface"

abstract struct Athena::Validator::Metadata::ClassMetadataBase; end

struct Athena::Validator::Metadata::ClassMetadata(T) < Athena::Validator::Metadata::ClassMetadataBase
  include Athena::Validator::Metadata::GenericMetadata
  include Athena::Validator::Metadata::ClassMetadataInterface

  def self.build : self
    class_metadata = new T

    {% begin %}
      # Add property constraints
      {% for ivar in T.instance_vars %}
        {% for constraint in AVD::Constraint.all_subclasses.reject &.abstract? %}
          {% ann_name = constraint.name(generic_args: false).split("::").last.id %}

          {% if ann = ivar.annotation Assert.constant(ann_name).resolve %}
            {% default_arg = ann.args.empty? ? nil : ann.args.first %}


            {% if default_arg.is_a? ArrayLiteral %}
              {% default_arg = default_arg.map do |arg|
                   if arg.is_a? Annotation
                     arg_name = arg.stringify.gsub(/@\[/, "").gsub(/\(.*/, "").split("::").last

                     inner_default_arg = arg.args.empty? ? nil : arg.args.first

                     # Resolve constraints from the annotations
                     %(AVD::Constraints::#{arg_name.id}.new(#{inner_default_arg ? "#{inner_default_arg},".id : "".id}#{arg.named_args.double_splat})).id
                   else
                     arg
                   end
                 end %}
            {% end %}

            class_metadata.add_property_constraint(
              AVD::Metadata::PropertyMetadata({{ivar.type}}, T).new({{ivar.name.stringify}}),
              {{constraint.name(generic_args: false).id}}.new(
                {{ default_arg ? "#{default_arg},".id : "".id }} # Default argument
                {{ ann.named_args.double_splat }}
              )
            )
          {% end %}
        {% end %}
      {% end %}

      # Add callback constraints
      {% for callback in T.methods.select &.annotation(Assert::Callback) %}
        class_metadata.add_constraint AVD::Constraints::Callback.new(callback_name: {{callback.name.stringify}}, {{callback.annotation(Assert::Callback).named_args.double_splat}})
      {% end %}

      {% for callback in T.class.methods.select &.annotation(Assert::Callback) %}
        class_metadata.add_constraint AVD::Constraints::Callback.new(callback: ->T.{{callback.name.id}}(AVD::Constraints::Callback::Value, AVD::ExecutionContextInterface, Hash(String, String)?), {{callback.annotation(Assert::Callback).named_args.double_splat}})
      {% end %}
    {% end %}

    # Also support adding constraints via code
    {% if T.class.has_method? :load_metadata %}
      T.load_metadata class_metadata
    {% end %}

    class_metadata
  end

  getter default_group : String
  getter class_name : AVD::Validatable

  @cascading_strategy : AVD::Metadata::CascadingStrategy = AVD::Metadata::CascadingStrategy::None
  @properties : Hash(String, AVD::Metadata::PropertyMetadataInterfaceBase) = Hash(String, AVD::Metadata::PropertyMetadataInterfaceBase).new

  def initialize(@class_name : AVD::Validatable)
    @default_group = @class_name.to_s
  end

  def add_constraint(constraint : AVD::Constraint) : AVD::Metadata::ClassMetadataBase
    constraint.add_implicit_group @default_group

    super constraint

    self
  end

  # Helper method to aid in adding constraints to properties via `.load_metadata`.
  def add_property_constraint(property_name : String, constraint : AVD::Constraint) : Nil forall IvarType
    {% begin %}
      property_metadata = case property_name
                            {% for ivar in T.instance_vars %}
                              when {{ivar.name.stringify}} then AVD::Metadata::PropertyMetadata({{ivar.type.id}}, T).new(property_name)
                            {% end %}
                          else
                            raise ArgumentError.new "Property '#{property_name}' does not exist in type '#{T}'."
                          end

    self.add_property_constraint property_metadata, constraint
    {% end %}
  end

  def add_property_constraint(property_metadata : AVD::Metadata::PropertyMetadataInterfaceBase, constraint : AVD::Constraint) : AVD::Metadata::ClassMetadataBase
    unless @properties.has_key? property_metadata.name
      @properties[property_metadata.name] = property_metadata
    end

    constraint.add_implicit_group @default_group

    @properties[property_metadata.name].add_constraint constraint

    self
  end

  def constrained_properties : Array(String)
    @properties.keys
  end

  def has_property_metadata?(property_name : String) : Bool
    @properties.has_key? property_name
  end

  def property_metadata(property_name : String) : AVD::Metadata::PropertyMetadataInterfaceBase
    @properties[property_name]
  end

  def name : String?
    nil
  end

  def invoke_callback(name : String, object : AVD::Validatable, context : AVD::ExecutionContextInterface, payload : Hash(String, String)?) : Nil
    {% begin %}
      case name
        {% for callback in T.methods.select &.annotation(Assert::Callback) %}
          when {{callback.name.stringify}}
            if object.responds_to?({{callback.name.id.symbolize}})
              object.{{callback.name.id}}(context, payload)
            end
        {% end %}
      else
        raise "BUG: Unknown method #{name} within #{T}"
      end
    {% end %}
  end
end
