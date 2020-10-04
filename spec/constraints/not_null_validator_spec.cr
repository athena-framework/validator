require "../spec_helper"

private alias CONSTRAINT = AVD::Constraints::NotNull

struct NotNullValidatorTest < AVD::Spec::ConstraintValidatorTestCase
  @[DataProvider("valid_values")]
  def test_valid_values(value : _) : Nil
    self.validator.validate value, self.new_constraint
    self.assert_no_violation
  end

  def valid_values : NamedTuple
    {
      string:       {""},
      bool_false:   {false},
      bool_true:    {true},
      zero:         {0},
      null_pointer: {Pointer(Void).null},
    }
  end

  def test_nil_is_invalid
    self.validator.validate nil, self.new_constraint message: "my_message"

    self
      .build_violation("my_message", CONSTRAINT::IS_NULL_ERROR, nil)
      .assert_violation
  end

  private def create_validator : AVD::ConstraintValidatorInterface
    CONSTRAINT::Validator.new
  end

  private def constraint_class : AVD::Constraint.class
    CONSTRAINT
  end
end
