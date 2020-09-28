require "../spec_helper"

private alias CONSTRAINT = AVD::Constraints::LessThan

struct LessThanValidatorTest < AVD::Spec::AbstractComparisonValidatorTestCase
  def valid_comparisons : NamedTuple
    {
      int:    {2, 3},
      string: {"a", "b"},
      time:   {Time.utc(2020, 4, 6), Time.utc(2020, 4, 7)},
      nil:    {nil, false},
    }
  end

  def invalid_comparisons : NamedTuple
    {
      int:       {3, 2},
      int_equal: {3, 3},
      string:    {"333", "22"},
      time:      {Time.utc(2020, 4, 8), Time.utc(2020, 4, 7)},
    }
  end

  def test_invalid_type : Nil
    expect_raises AVD::Exceptions::UnexpectedValueError, "Expected argument of type 'Number | String | Time', 'Bool' given." do
      self.validator.validate false, new_constraint value: 50
    end
  end

  def error_code : String
    CONSTRAINT::TOO_HIGH_ERROR
  end

  def create_validator : AVD::ConstraintValidatorInterface
    CONSTRAINT::Validator.new
  end

  def constraint_class : AVD::Constraint.class
    CONSTRAINT
  end
end
