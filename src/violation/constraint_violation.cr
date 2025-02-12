require "./constraint_violation_interface"

# Basic implementation of `AVD::Violation::ConstraintViolationInterface`.
struct Athena::Validator::Violation::ConstraintViolation
  include Athena::Validator::Violation::ConstraintViolationInterface

  protected getter invalid_value_container : AVD::Container
  protected getter root_container : AVD::Container

  # :inherit:
  getter cause : String?

  # :inherit:
  getter code : String?

  # :inherit:
  getter! constraint : AVD::Constraint

  # :inherit:
  getter message : String

  # :inherit:
  getter message_template : String?

  # :inherit:
  getter parameters : Hash(String, String)

  # :inherit:
  getter plural : Int32?

  # :inherit:
  getter property_path : String

  def initialize(
    @message : String,
    @message_template : String?,
    @parameters : Hash(String, String),
    root : _,
    @property_path : String,
    @invalid_value_container : AVD::Container,
    @plural : Int32? = nil,
    @code : String? = nil,
    @constraint : AVD::Constraint? = nil,
    @cause : String? = nil,
  )
    @root_container = root.is_a?(AVD::Container) ? root : AVD::ValueContainer.new(root)
  end

  # :inherit:
  def invalid_value
    @invalid_value_container.value
  end

  # :inherit:
  def root
    @root_container.value
  end

  # :inherit:
  def to_json(builder : JSON::Builder) : Nil
    builder.object do
      builder.field "property", @property_path
      builder.field "message", @message

      if code = @code
        builder.field "code", code
      end
    end
  end

  # :inherit:
  def to_s(io : IO) : Nil
    klass = case self.root
            when Hash                         then "Hash"
            when AVD::Validatable, Enumerable then "Object(#{self.root.class})"
            else
              self.root.to_s
            end

    klass += '.' if !@property_path.blank? && !@property_path.starts_with?('[') && !klass.blank?

    if (c = code) && !c.blank?
      code = " (code: #{c})"
    end

    io << klass
    io << @property_path
    io << ':' << '\n' << '\t'
    io << @message
    io << code
    io << '\n'
  end

  # Returns `true` if *other* is the same as `self`, otherwise `false`.
  def ==(other : AVD::Violation::ConstraintViolationInterface) : Bool
    @message == other.message &&
      @message_template == other.message_template &&
      @parameters == other.parameters &&
      @root_container == other.root_container &&
      @property_path == other.property_path &&
      @invalid_value_container == other.invalid_value_container &&
      @plural == other.plural &&
      @code == other.code &&
      @constraint == other.constraint? &&
      @cause == other.cause
  end
end
