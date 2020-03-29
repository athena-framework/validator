require "./constraint_violation_interface"

struct Athena::Validator::Violation::ConstraintViolation(Root, InvalidValueType)
  include Athena::Validator::Violation::ConstraintViolationInterface

  getter invalid_value : InvalidValueType
  getter message : String
  getter message_template : String?
  getter parameters : Hash(String, String)
  getter plural : Int32?
  getter root : Root
  getter constraint : AVD::Constraint?
  getter property_path : String
  getter code : String?
  getter cause : String?

  def initialize(
    @message : String,
    @message_template : String?,
    @parameters : Hash(String, String),
    @root : Root,
    @property_path : String,
    @invalid_value : InvalidValueType,
    @plural : Int32? = nil,
    @code : String? = nil,
    @constraint : AVD::Constraint? = nil,
    @cause : String? = nil
  )
  end

  def to_s(io : IO) : Nil
    klass = case @root
            when Hash             then "Hash"
            when AVD::Validatable then "Object(#{@root.class})"
            else
              @root.to_s
            end

    klass += '.' if !@property_path.blank? && !@property_path.starts_with?('[') && !klass.blank?

    if (c = code) && !c.blank?
      code = " (code: #{c})"
    end

    io.puts "#{klass}#{@property_path}:\n\t#{@message}#{code}"
  end

  def ==(other) : Bool
    @message == other.message &&
      @message_template == other.message_template &&
      @parameters == other.parameters &&
      @root == other.root &&
      @property_path == other.property_path &&
      @invalid_value == other.invalid_value &&
      @plural == other.plural &&
      @code == other.code &&
      @constraint == other.constraint &&
      @cause == other.cause
  end
end
