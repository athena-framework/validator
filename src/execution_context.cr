require "./validator/validator_interface"
require "./execution_context_interface"

class Athena::Validator::ExecutionContext(Root)
  include Athena::Validator::ExecutionContextInterface

  property constraint : AVD::Constraint?
  property group : String?

  getter validator : AVD::Validator::ValidatorInterface
  getter violations : AVD::Violation::ConstraintViolationList = AVD::Violation::ConstraintViolationList.new
  getter property_path : String = ""
  getter metadata : AVD::Metadata::MetadataInterface? = nil

  # The value that is currently being validated.
  @value_container : AVD::Container = AVD::ValueContainer.new(nil)

  # The object initially passed to `#validate`.
  getter root : Root

  # The object that is currently being validated.
  getter object_container : AVD::Container = AVD::ValueContainer.new(nil)

  def initialize(@validator : AVD::Validator::ValidatorInterface, @root : Root); end

  def value
    @value_container.value
  end

  def object
    @object_container.value
  end

  def class_name
    @metadata.try &.class_name
  end

  def property_name : String?
    @metadata.try &.name
  end

  def path(path : String) : String
    AVD::PropertyPath.append @property_path, path
  end

  # :nodoc:
  def set_node(value : _, object : _, metadata : AVD::Metadata::MetadataInterface?, property_path : String) : Nil
    @value_container = AVD::ValueContainer.new value
    @object_container = AVD::ValueContainer.new object
    @metadata = metadata
    @property_path = property_path
  end

  def add_violation(message : String, parameters : Hash(String, String) = {} of String => String) : Nil
    rendered_message = message.gsub(/(?:{{ \w+ }})+/, parameters)

    @violations.add AVD::Violation::ConstraintViolation.new(
      rendered_message,
      message,
      parameters,
      @root,
      @property_path,
      @value_container,
      constraint: @constraint
    )
  end

  def build_violation(message : String, parameters : Hash(String, String) = {} of String => String) : AVD::Violation::ConstraintViolationBuilderInterface
    AVD::Violation::ConstraintViolationBuilder.new(
      @violations,
      @constraint,
      message,
      parameters,
      @root,
      @property_path,
      @value_container,
    )
  end
end
