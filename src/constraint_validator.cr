require "./constraint_validator_interface"

abstract struct Athena::Validator::ConstraintValidator
  include Athena::Validator::ConstraintValidatorInterface

  # :nodoc:
  #
  # Denotes a built in validator that can be instantiated directly via `.new`.
  module Basic; end

  @context : AVD::ExecutionContextInterface?

  def context : AVD::ExecutionContextInterface
    @context.not_nil!
  end

  # :nodoc:
  def context=(@context : AVD::ExecutionContextInterface); end

  def validate(value : _, constraint : AVD::Constraint) : Nil
    # Noop if a given validator doesn't support a given type of value
  end

  private def raise_invalid_type(value : _, supported_types : String) : NoReturn
    raise AVD::Exceptions::UnexpectedValueError.new value, supported_types
  end
end
