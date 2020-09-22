require "../spec_helper"

struct IsNullValidatorTest < AVD::Spec::ConstraintValidatorTestCase
  def test_nil_is_valid : Nil
    constraint = self.new_constraint

    self.validator.validate nil, constraint

    self.assert_no_violation
  end

  @[DataProvider("invalid_values")]
  def test_invalid_values(value : _) : Nil
    constraint = self.new_constraint message: "my_message"

    self.validator.validate value, constraint

    self.build_violation("my_message")
      .add_parameter("{{ value }}", value)
      .code(AVD::Constraints::IsNull::NOT_NULL_ERROR)
      .assert_violation
  end

  def invalid_values : Tuple
    {
      {"foobar"},
      {0},
      {false},
      {true},
      {""},
      {Time.utc},
      {[] of Int32},
      {Pointer(Void).null},
      {1234},
    }
  end

  private def create_validator : AVD::ConstraintValidatorInterface
    AVD::Constraints::IsNull::Validator.new
  end

  private def constraint_class : AVD::Constraint.class
    AVD::Constraints::IsNull
  end
end
