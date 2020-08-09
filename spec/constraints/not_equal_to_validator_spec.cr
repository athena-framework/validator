require "../spec_helper"

struct NotEqualToValidatorTest < AVD::Spec::AbstractComparisonValidatorTestCase
  def valid_comparisons : NamedTuple
    {
      int:    {1, 2},
      char:   {'b', 'a'},
      string: {"b", "a"},
      time:   {Time.utc(2020, 4, 8), Time.utc(2020, 4, 7)},
      nil:    {nil, false},

    }
  end

  def invalid_comparisons : NamedTuple
    {
      int:    {3, 3},
      char:   {'a', 'a'},
      string: {"a", "a"},
      time:   {Time.utc(2020, 4, 7), Time.utc(2020, 4, 7)},
    }
  end

  def error_code : String
    AVD::Constraints::NotEqualTo::IS_EQUAL_ERROR
  end

  def create_validator : AVD::ConstraintValidatorInterface
    AVD::Constraints::NotEqualTo::Validator.new
  end

  def constraint_class : AVD::Constraint.class
    AVD::Constraints::NotEqualTo
  end
end
