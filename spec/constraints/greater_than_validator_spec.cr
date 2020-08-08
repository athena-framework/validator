require "../spec_helper"

struct GreaterThanValidatorTest < AVD::Spec::AbstractComparisonValidatorTestCase
  def valid_comparisons
    {
      int:    {3, 2},
      string: {"333", "22"},
      time:   {Time.utc(2020, 4, 8), Time.utc(2020, 4, 7)},
      nil:    {nil, false},
    }
  end

  def invalid_comparisons
    {
      int:       {2, 3},
      int_equal: {3, 3},
      string:    {"a", "b"},
      time:      {Time.utc(2020, 4, 6), Time.utc(2020, 4, 7)},
    }
  end

  def error_code
    AVD::Constraints::GreaterThan::TOO_LOW_ERROR
  end

  def create_validator : AVD::ConstraintValidatorInterface
    AVD::Constraints::GreaterThan::Validator.new
  end

  def constraint_class : AVD::Constraint.class
    AVD::Constraints::GreaterThan
  end
end
