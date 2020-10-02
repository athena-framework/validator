require "./generic_metadata"
require "./class_metadata_interface"

abstract struct Athena::Validator::Metadata::ClassMetadataBase; end

struct Athena::Validator::Metadata::ClassMetadata(T) < Athena::Validator::Metadata::ClassMetadataBase
  include Athena::Validator::Metadata::GenericMetadata
  include Athena::Validator::Metadata::ClassMetadataInterface

  # Builds `self`, auto registering any annotation based annotations on `T`,
  # as well as those registered via `T.load_metadata`.
  def self.build : self
    class_metadata = new

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

                     # Resolve constraints from the annotations,
                     # TODO: Figure out a better way to do this.
                     %(AVD::Constraints::#{arg_name.id}.new(#{inner_default_arg ? "#{inner_default_arg},".id : "".id}#{arg.named_args.double_splat})).id
                   else
                     arg
                   end
                 end %}
            {% end %}

            class_metadata.add_property_constraint(
              AVD::Metadata::PropertyMetadata(T).new({{ivar.name.stringify}}),
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

    # Check for group sequences
    {% if group_sequence = T.annotation Assert::GroupSequence %}
      class_metadata.group_sequence = [{{group_sequence.args.splat}}]
    {% end %}

    class_metadata
  end

  getter default_group : String
  getter group_sequence : AVD::Constraints::GroupSequence? = nil

  @cascading_strategy : AVD::Metadata::CascadingStrategy = AVD::Metadata::CascadingStrategy::None
  @properties : Hash(String, AVD::Metadata::PropertyMetadataInterfaceBase) = Hash(String, AVD::Metadata::PropertyMetadataInterfaceBase).new

  def initialize
    @default_group = T.to_s
  end

  def class_name : T.class
    T
  end

  def add_constraint(constraints : Array(AVD::Constraint)) : AVD::Metadata::ClassMetadataBase
    constraints.each do |constraint|
      self.add_constraint constraint
    end

    self
  end

  def add_constraint(constraint : AVD::Constraint) : AVD::Metadata::ClassMetadataBase
    constraint.add_implicit_group @default_group

    super constraint

    self
  end

  # Helper method to aid in adding constraints to properties via `.load_metadata`.
  def add_property_constraints(property_hash : Hash(String, AVD::Constraint | Array(AVD::Constraint))) : Nil
    property_hash.each do |property_name, constraints|
      self.add_property_constraint property_name, constraints
    end
  end

  # :ditto:
  def add_property_constraint(property_name : String, constraints : Array(AVD::Constraint)) : Nil
    constraints.each do |constraint|
      self.add_property_constraint property_name, constraint
    end
  end

  # :ditto:
  def add_property_constraint(property_name : String, constraint : AVD::Constraint) : Nil
    self.add_property_constraint AVD::Metadata::PropertyMetadata(T).new(property_name), constraint
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

  def group_sequence=(sequence : Array(String) | AVD::Constraints::GroupSequence) : self
    raise ArgumentError.new "Defining a static group sequence is not allowed with a group sequence provider." if @group_sequence_provider

    if sequence.is_a? Array
      sequence = AVD::Constraints::GroupSequence.new sequence
    end

    if sequence.groups.includes? AVD::Constraint::DEFAULT_GROUP
      raise ArgumentError.new "The group '#{AVD::Constraint::DEFAULT_GROUP}' is not allowed in group sequences."
    end

    unless sequence.groups.includes? @default_group
      raise ArgumentError.new "The group '#{@default_group}' is missing from the group sequence."
    end

    @group_sequence = sequence

    self
  end

  def group_sequence_provider=(active : Bool) : Nil
    raise ArgumentError.new "Defining a group sequence provider is not allowed with a static group sequence." unless @group_sequence.nil?
    # TODO: ensure `T` implements the module interface
    @group_sequence_provider = active
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
