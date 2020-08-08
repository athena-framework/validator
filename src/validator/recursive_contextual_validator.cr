struct Athena::Validator::Validator::RecursiveContextualValidator
  include Athena::Validator::Validator::ContextualValidatorInterface

  @default_groups : Array(String)
  @default_property_path : String

  def initialize(@context : AVD::ExecutionContextInterface, @constraint_validator_factory : AVD::ConstraintValidatorFactoryInterface)
    @default_groups = [(g = @context.group) ? g : Constraint::DEFAULT_GROUP]
    @default_property_path = @context.property_path
  end

  def at_path(path : String) : AVD::Validator::ContextualValidatorInterface
    @default_property_path = @context.path path

    self
  end

  def validate(value : _, constraints : Array(AVD::Constraint)? = nil, groups : Array(String)? = nil) : AVD::Validator::ContextualValidatorInterface
    groups = groups || @default_groups

    previous_value = @context.value
    previous_object = @context.object
    previous_metadata = @context.metadata
    previous_path = @context.property_path
    previous_group = @context.group
    previous_constraint = @context.is_a?(AVD::ExecutionContext) ? @context.constraint : nil

    # Validate the value against explicitly passed constraints
    unless constraints.nil?
      metadata = AVD::Metadata::Metadata.new
      metadata.add_constraints constraints

      self.validate_generic_node(
        value,
        previous_object,
        metadata,
        @default_property_path,
        groups,
        AVD::Metadata::TraversalStrategy::Implicit,
        @context
      )

      @context.set_node previous_value, previous_object, previous_metadata, previous_path
      @context.group = previous_group

      unless previous_constraint.nil?
        @context.constraint = previous_constraint
      end

      return self
    end

    case value
    when AVD::Validatable
      self.validate_object(
        value,
        @default_property_path,
        groups,
        AVD::Metadata::TraversalStrategy::Implicit,
        @context
      )

      @context.set_node previous_value, previous_object, previous_metadata, previous_path
      @context.group = previous_group

      self
    when Iterable, Hash
      self.validate_each_object_in(
        value,
        @default_property_path,
        groups,
        @context
      )

      @context.set_node previous_value, previous_object, previous_metadata, previous_path
      @context.group = previous_group

      self
    else
      raise "Could not validate #{value}"
    end
  end

  def validate_property(object : AVD::Validatable, property_name : String, groups : Array(String)? = nil) : AVD::Validator::ContextualValidatorInterface
    class_metadata = object.validation_metadata
    property_metadata = class_metadata.property_metadata(property_name)
    groups = groups || @default_groups
    property_path = AVD::PropertyPath.append @default_property_path, property_name

    previous_value = @context.value
    previous_object = @context.object
    previous_metadata = @context.metadata
    previous_path = @context.property_path
    previous_group = @context.group

    property_value = property_metadata.value

    self.validate_generic_node(
      property_value,
      object,
      property_metadata,
      property_path,
      groups,
      AVD::Metadata::TraversalStrategy::Implicit,
      @context
    )

    @context.set_node previous_value, previous_object, previous_metadata, previous_path
    @context.group = previous_group

    self
  end

  def validate_property_value(object : AVD::Validatable, property_name : String, value : _, groups : Array(String)? = nil) : AVD::Validator::ContextualValidatorInterface
    class_metadata = object.validation_metadata
    property_metadata = class_metadata.property_metadata(property_name)
    groups = groups || @default_groups
    property_path = AVD::PropertyPath.append @default_property_path, property_name

    previous_value = @context.value
    previous_object = @context.object
    previous_metadata = @context.metadata
    previous_path = @context.property_path
    previous_group = @context.group

    self.validate_generic_node(
      value,
      object,
      property_metadata,
      property_path,
      groups,
      AVD::Metadata::TraversalStrategy::Implicit,
      @context
    )

    @context.set_node previous_value, previous_object, previous_metadata, previous_path
    @context.group = previous_group

    self
  end

  private def validate_each_object_in(
    collection : Iterable,
    property_path : String,
    groups : Array(String),
    context : AVD::ExecutionContextInterface
  )
    collection.each_with_index do |item, idx|
      case item
      when Iterable, Hash   then self.validate_each_object_in(item, "#{property_path}[#{idx}]", groups, context)
      when AVD::Validatable then self.validate_object(item, "#{property_path}[#{idx}]", groups, AVD::Metadata::TraversalStrategy::Implicit, context)
      else                       raise "unreachable?"
      end
    end
  end

  private def validate_each_object_in(
    collection : Hash,
    property_path : String,
    groups : Array(String),
    context : AVD::ExecutionContextInterface
  )
    collection.each do |key, value|
      case value
      when Iterable, Hash   then self.validate_each_object_in(value, "#{property_path}[#{key}]", groups, context)
      when AVD::Validatable then self.validate_object(value, "#{property_path}[#{key}]", groups, AVD::Metadata::TraversalStrategy::Implicit, context)
      else                       raise "unreachable?"
      end
    end
  end

  private def validate_generic_node(
    value : _,
    object : _,
    metadata : AVD::Metadata::MetadataInterface?,
    property_path : String,
    groups : Array(String),
    traversal_strategy : AVD::Metadata::TraversalStrategy,
    context : AVD::ExecutionContextInterface
  )
    context.set_node value, object, metadata, property_path

    groups.each do |group|
      self.validate_in_group value, metadata, group, context
    end

    return if value.nil?

    cascading_strategy = metadata.cascading_strategy

    return unless cascading_strategy.cascade?
    return unless value.is_a? Iterable

    self.validate_each_object_in(
      value,
      property_path,
      groups,
      context
    )
  end

  private def validate_object(object : AVD::Validatable, property_path : String, groups : Array(String), traversal_strategy : AVD::Metadata::TraversalStrategy, context : AVD::ExecutionContextInterface) : Nil
    class_metadata = object.validation_metadata

    self.validate_class_node(
      object,
      class_metadata,
      property_path,
      groups,
      traversal_strategy,
      context
    )
  end

  private def validate_class_node(
    object : AVD::Validatable,
    class_metadata : AVD::Metadata::ClassMetadata,
    property_path : String,
    groups : Array(String),
    traversal_strategy : AVD::Metadata::TraversalStrategy,
    context : AVD::ExecutionContextInterface
  ) : Nil
    context.set_node object, object, class_metadata, property_path

    groups.each do |group|
      # TODO: Can cache validated groups here if needed in the future
      self.validate_in_group object, class_metadata, group, context
    end

    class_metadata.constrained_properties.each do |property_name|
      property_metadata = class_metadata.property_metadata(property_name)
      property_value = property_metadata.value

      self.validate_generic_node(
        property_value,
        object,
        property_metadata,
        AVD::PropertyPath.append(property_path, property_name),
        groups,
        AVD::Metadata::TraversalStrategy::Implicit,
        context
      )
    end

    traversal_strategy = class_metadata.traversal_strategy if traversal_strategy.implicit?

    return if traversal_strategy.none?
    return if traversal_strategy.implicit? && !object.is_a? Iterable
    return unless object.is_a? Iterable

    self.validate_each_object_in(
      object,
      property_path,
      groups,
      context
    )
  end

  def validate_in_group(value : _, metadata : AVD::Metadata::MetadataInterface, group : String, context : AVD::ExecutionContextInterface) : Nil
    context.group = group

    metadata.find_constraints(group).each do |constraint|
      # TODO: Can cache validated groups here if needed in the future
      context.constraint = constraint.value

      validator = @constraint_validator_factory.validator constraint.value
      pp typeof(validator)
      validator.context = context

      validator.validate value, constraint.value
    rescue type_error : AVD::Exceptions::UnexpectedValueError
      context
        .build_violation("This value should be a valid: {{ type }}")
        .add_parameter("{{ type }}", type_error.expected_type)
        .add
    end
  end

  def violations : AVD::Violation::ConstraintViolationListInterface
    @context.violations
  end
end
