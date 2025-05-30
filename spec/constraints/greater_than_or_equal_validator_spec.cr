require "../spec_helper"

private alias CONSTRAINT = AVD::Constraints::GreaterThanOrEqual

struct GreaterThanOrEqualValidatorTest < AVD::Spec::ComparisonConstraintValidatorTestCase
  def valid_comparisons : Tuple
    {
      {3, 2},
      {0, 0_u8},
      {"333", "22"},
      {"22", "22"},
      {Time.utc(2020, 4, 8), Time.utc(2020, 4, 7)},
      {nil, false},
    }
  end

  def invalid_comparisons : Tuple
    {
      {2, 3},
      {"a", "b"},
      {Time.utc(2020, 4, 6), Time.utc(2020, 4, 7)},
    }
  end

  def test_invalid_type : Nil
    expect_raises AVD::Exception::UnexpectedValueError, "Expected argument of type 'Number | String | Time', 'Bool' given." do
      self.validator.validate false, new_constraint value: 50
    end
  end

  def error_code : String
    CONSTRAINT::TOO_LOW_ERROR
  end

  def create_validator : AVD::ConstraintValidatorInterface
    CONSTRAINT::Validator.new
  end

  def constraint_class : AVD::Constraint.class
    CONSTRAINT
  end
end
