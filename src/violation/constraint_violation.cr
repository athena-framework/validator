require "./constraint_violation_interface"

struct Athena::Validator::Violation::ConstraintViolation(Root)
  include Athena::Validator::Violation::ConstraintViolationInterface

  @invalid_value : AVD::Container

  getter message : String
  getter message_template : String?
  getter parameters : Hash(String, String)
  getter plural : Int32?
  getter root : Root
  getter constraint : AVD::Constraint
  getter property_path : String
  getter code : String
  getter cause : String?

  def initialize(
    @message : String,
    @message_template : String?,
    @parameters : Hash(String, String),
    @plural : Int32?,
    @root : Root,
    @constraint : AVD::Constraint,
    @property_path : String,
    invalid_value : _,
    @code : String,
    @cause : String?
  )
    @invalid_value = AVD::ValueContainer.new invalid_value
  end

  def invalid_value
    @invalid_value.value
  end

  def to_s(io : IO) : Nil
    String.build(io) do |str|
      klass = case @root
              when Array  then "Array"
              when Object then "Object#{{{@type}}}"
              else
                @root.to_s
              end

      str << klass
      str << @property_path
      str << @message

      if (code = @code) && !code.blank?
        str << " #{code}"
      end
    end
  end
end
