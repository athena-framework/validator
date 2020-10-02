require "../constraint_validator_factory_interface"

class Athena::Validator::Validator::RecursiveValidator
  include Athena::Validator::Validator::ValidatorInterface

  @validator_factory : AVD::ConstraintValidatorFactoryInterface

  def initialize(validator_factory : AVD::ConstraintValidatorFactoryInterface? = nil)
    @validator_factory = validator_factory || AVD::ConstraintValidatorFactory.new
  end

  def validate(value : _, constraints : Array(AVD::Constraint) | AVD::Constraint | Nil = nil, groups : Array(String) | String | AVD::Constraints::GroupSequence | Nil = nil) : AVD::Violation::ConstraintViolationListInterface
    start_context(value).validate(value, constraints, groups).violations
  end

  def validate_property(object : AVD::Validatable, property_name : String, groups : Array(String) | String | AVD::Constraints::GroupSequence | Nil = nil) : AVD::Violation::ConstraintViolationListInterface
    start_context(object).validate_property(object, property_name, groups).violations
  end

  def validate_property_value(object : AVD::Validatable, property_name : String, value : _, groups : Array(String) | String | AVD::Constraints::GroupSequence | Nil = nil) : AVD::Violation::ConstraintViolationListInterface
    start_context(object).validate_property_value(object, property_name, value, groups).violations
  end

  def start_context(root = nil) : AVD::Validator::ContextualValidatorInterface
    AVD::Validator::RecursiveContextualValidator.new create_context(root), @validator_factory
  end

  def in_context(context : AVD::ExecutionContextInterface) : AVD::Validator::ContextualValidatorInterface
    AVD::Validator::RecursiveContextualValidator.new context, @validator_factory
  end

  private def create_context(root = nil) : AVD::ExecutionContextInterface
    AVD::ExecutionContext.new self, root
  end
end
