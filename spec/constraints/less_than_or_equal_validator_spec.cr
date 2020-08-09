require "../spec_helper"

struct LessThanOrEqualValidatorTest < AVD::Spec::AbstractComparisonValidatorTestCase
  def valid_comparisons : NamedTuple
    {
      int:          {2, 3},
      int_equal:    {0, 0_u8},
      string:       {"a", "b"},
      string_equal: {"22", "22"},
      time:         {Time.utc(2020, 4, 6), Time.utc(2020, 4, 7)},
      nil:          {nil, false},
    }
  end

  def invalid_comparisons : NamedTuple
    {
      int:    {3, 2},
      string: {"333", "22"},
      time:   {Time.utc(2020, 4, 8), Time.utc(2020, 4, 7)},
    }
  end

  def test_invalid_type : Nil
    expect_raises AVD::Exceptions::UnexpectedValueError, "Expected argument of type 'Number | String | Time', 'Bool' given." do
      self.validator.validate false, new_constraint value: 50
    end
  end

  def error_code : String
    AVD::Constraints::LessThanOrEqual::TOO_HIGH_ERROR
  end

  def create_validator : AVD::ConstraintValidatorInterface
    AVD::Constraints::LessThanOrEqual::Validator.new
  end

  def constraint_class : AVD::Constraint.class
    AVD::Constraints::LessThanOrEqual
  end
end
