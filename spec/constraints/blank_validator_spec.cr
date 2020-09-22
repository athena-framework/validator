require "../spec_helper"

struct BlankValidatorTest < AVD::Spec::ConstraintValidatorTestCase
  def test_nil_is_valid : Nil
    constraint = self.new_constraint

    self.validator.validate nil, constraint

    self.assert_no_violation
  end

  def test_blank_is_valid : Nil
    constraint = self.new_constraint

    self.validator.validate "", constraint

    self.assert_no_violation
  end

  def test_blank_spaces_is_valid : Nil
    constraint = self.new_constraint

    self.validator.validate "   ", constraint

    self.assert_no_violation
  end

  @[DataProvider("invalid_values")]
  def test_invalid_values(value : _) : Nil
    constraint = self.new_constraint message: "my_message"

    self.validator.validate value, constraint

    self.build_violation("my_message")
      .add_parameter("{{ value }}", value)
      .code(AVD::Constraints::Blank::NOT_BLANK_ERROR)
      .assert_violation
  end

  def invalid_values : Tuple
    {
      {"foobar"},
      {0},
      {false},
      {1234},
    }
  end

  private def create_validator : AVD::ConstraintValidatorInterface
    AVD::Constraints::Blank::Validator.new
  end

  private def constraint_class : AVD::Constraint.class
    AVD::Constraints::Blank
  end
end
