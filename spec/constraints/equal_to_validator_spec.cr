require "../spec_helper"

struct EqualToValidatorTest < AVD::Spec::AbstractComparisonValidatorTestCase
  def valid_comparisons
    {
      int:    {3, 3},
      char:   {'a', 'a'},
      string: {"a", "a"},
      time:   {Time.utc(2020, 4, 7), Time.utc(2020, 4, 7)},
      nil:    {nil, false},
    }
  end

  def invalid_comparisons
    {
      int:    {1, 3},
      char:   {'b', 'a'},
      string: {"b", "a"},
      time:   {Time.utc(2020, 4, 8), Time.utc(2020, 4, 7)},
    }
  end

  def error_code
    AVD::Constraints::EqualTo::NOT_EQUAL_ERROR
  end

  def create_validator : AVD::ConstraintValidatorInterface
    AVD::Constraints::EqualTo::Validator.new
  end

  def constraint_class : AVD::Constraint.class
    AVD::Constraints::EqualTo
  end
end
