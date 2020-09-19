require "./constraint_violation_builder_interface"

class Athena::Validator::Violation::ConstraintViolationBuilder(Root)
  include Athena::Validator::Violation::ConstraintViolationBuilderInterface

  @plural : Int32?
  @cause : String?
  @invalid_value : AVD::Container

  def initialize(
    @violations : AVD::Violation::ConstraintViolationListInterface,
    @constraint : AVD::Constraint?,
    @message : String,
    @parameters : Hash(String, String),
    @root : Root,
    @property_path : String,
    invalid_value : _
  )
    @invalid_value = AVD::ValueContainer.new invalid_value
  end

  def at_path(path : String) : AVD::Violation::ConstraintViolationBuilderInterface
    @property_path = AVD::PropertyPath.append @property_path, path

    self
  end

  def add_parameter(key : String, value : _) : AVD::Violation::ConstraintViolationBuilderInterface
    @parameters[key] = value.to_s

    self
  end

  def set_parameters(@parameters : Hash(String, String)) : AVD::Violation::ConstraintViolationBuilderInterface
    self
  end

  def invalid_value(value : _) : AVD::Violation::ConstraintViolationBuilderInterface
    @invalid_value = AVD::ValueContainer.new value

    self
  end

  def plural(@plural : Int32) : AVD::Violation::ConstraintViolationBuilderInterface
    self
  end

  def code(@code : String?) : AVD::Violation::ConstraintViolationBuilderInterface
    self
  end

  def cause(@cause : String?) : AVD::Violation::ConstraintViolationBuilderInterface
    self
  end

  def constraint(@constraint : AVD::Constraint?) : AVD::Violation::ConstraintViolationBuilderInterface
    self
  end

  def add : Nil
    # Split and determine the message to use based on plural value
    translated_message = if !(count = @plural).nil? && @message.includes? '|'
                           parts = @message.split('|')
                           # TODO: Support more robust translations
                           count == 1 ? parts.first : parts[1]
                         else
                           @message
                         end

    rendered_message = translated_message.gsub(/(?:{{ \w+ }})+/, @parameters)

    @violations.add AVD::Violation::ConstraintViolation.new(
      rendered_message,
      @message,
      @parameters,
      @root,
      @property_path,
      @invalid_value.value,
      @plural,
      @code,
      @constraint,
      @cause
    )
  end
end
