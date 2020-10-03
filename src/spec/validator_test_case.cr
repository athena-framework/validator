abstract struct Athena::Validator::Spec::ValidatorTestCase < AVD::Spec::AbstractValidatorTestCase
  getter! validator : AVD::Validator::ValidatorInterface

  def initialize
    super

    @validator = self.create_validator @metadata_factory
  end

  abstract def create_validator(metadata_factory : AVD::Metadata::MetadataFactoryInterface) : AVD::Validator::ValidatorInterface

  def validate(value, constraints = nil, groups = nil) : AVD::Violation::ConstraintViolationListInterface
    self.validator.validate value, constraints, groups
  end

  def validate_property(object, property_name, groups = nil) : AVD::Violation::ConstraintViolationListInterface
    self.validator.validate_property object, property_name, groups
  end

  def validate_property_value(object, property_name, value, groups = nil) : AVD::Violation::ConstraintViolationListInterface
    self.validator.validate_property_value object, property_name, value, groups
  end

  def test_validate_constraint_without_group
    self.validate(nil, AVD::Constraints::NotNull.new).size.should eq 1
  end

  def test_validate_empty_array_as_constraint
    self.validate(nil, [] of AVD::Constraint).should be_empty
  end
end
