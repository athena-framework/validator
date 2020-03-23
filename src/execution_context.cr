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

  def property_name : String?
    (m = @metadata).is_a?(AVD::Metadata::PropertyMetadataInterfaceBase) ? m.name : nil
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

  def add(message : String, parameters : Hash(String, String) = {} of String => String) : Nil
    rendered_message = message.gsub(/(?:{{ \w+ }})+/, parameters)

    @violations << AVD::Violation::ConstraintViolation.new(
      rendered_message,
      message,
      parameters,
      @root,
      @property_path,
      self.value,
      nil,
      nil,
      @constraint.not_nil!, # Is set via the validator
    )
  end

  def build(message : String, parameters : Hash(String, String) = {} of String => String) : AVD::Violation::ConstraintViolationBuilderInterface
    AVD::Violation::ConstraintViolationBuilder.new(
      @violations,
      @constraint.not_nil!, # Is set via the validator
      message,
      parameters,
      @root,
      @property_path,
      self.value
    )
  end
end
