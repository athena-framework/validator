require "../spec_helper"

private class Stringifiable
  def initialize(@value : String); end

  def to_s(io : IO) : Nil
    io << @value
  end
end

struct RegexValidatorTest < AVD::Spec::ConstraintValidatorTestCase
  def test_nil_is_valid : Nil
    self.validator.validate nil, self.new_constraint pattern: /^[0-9]+$/
    self.assert_no_violation
  end

  def test_empty_string_is_valid : Nil
    self.validator.validate "", self.new_constraint pattern: /^[0-9]+$/
    self.assert_no_violation
  end

  @[DataProvider("valid_values")]
  def test_valid_values(value : _) : Nil
    self.validator.validate value, self.new_constraint pattern: /^[0-9]+$/
    self.assert_no_violation
  end

  def valid_values : Tuple
    {
      {0},
      {"0"},
      {909090},
      {"0909090"},
      {Stringifiable.new("909090")},
    }
  end

  @[DataProvider("invalid_values")]
  def test_invalid_values(value : _) : Nil
    constraint = self.new_constraint pattern: /^[0-9]+$/, message: "my_message"

    self.validator.validate value, constraint

    self.build_violation("my_message")
      .add_parameter("{{ value }}", value)
      .code(AVD::Constraints::Regex::REGEX_FAILED_ERROR)
      .assert_violation
  end

  def invalid_values : Tuple
    {
      {"abcd"},
      {"090foo"},
      {Stringifiable.new("abcd")},
    }
  end

  private def create_validator : AVD::ConstraintValidatorInterface
    AVD::Constraints::Regex::Validator.new
  end

  private def constraint_class : AVD::Constraint.class
    AVD::Constraints::Regex
  end
end
