require "../spec_helper"

struct NotBlankValidatorTest < AVD::Spec::ConstraintValidatorTestCase
  @[DataProvider("valid_values")]
  def test_valid_values(value : _) : Nil
    self.validator.validate value, self.new_constraint
    self.assert_no_violation
  end

  def valid_values : NamedTuple
    {
      string: {"foo"},
      array:  {[1, 2, 3]},
      bool:   {true},
    }
  end

  def test_nil_is_invalid
    constraint = self.new_constraint message: "my_message"

    self.validator.validate nil, constraint

    self.build_violation("my_message")
      .add_parameter("{{ value }}", nil)
      .code(AVD::Constraints::NotBlank::IS_BLANK_ERROR)
      .assert_violation
  end

  def test_blank_is_invalid
    constraint = self.new_constraint message: "my_message"

    self.validator.validate "", constraint

    self.build_violation("my_message")
      .add_parameter("{{ value }}", "")
      .code(AVD::Constraints::NotBlank::IS_BLANK_ERROR)
      .assert_violation
  end

  def test_false_is_invalid
    constraint = self.new_constraint message: "my_message"

    self.validator.validate false, constraint

    self.build_violation("my_message")
      .add_parameter("{{ value }}", false)
      .code(AVD::Constraints::NotBlank::IS_BLANK_ERROR)
      .assert_violation
  end

  def test_empty_array_is_invalid
    constraint = self.new_constraint message: "my_message"

    self.validator.validate [] of String, constraint

    self.build_violation("my_message")
      .add_parameter("{{ value }}", [] of String)
      .code(AVD::Constraints::NotBlank::IS_BLANK_ERROR)
      .assert_violation
  end

  def test_allow_nil_true
    constraint = self.new_constraint message: "my_message", allow_nil: true

    self.validator.validate nil, constraint
    self.assert_no_violation
  end

  def test_allow_nil_false
    constraint = self.new_constraint message: "my_message", allow_nil: false

    self.validator.validate nil, constraint

    self.build_violation("my_message")
      .add_parameter("{{ value }}", nil)
      .code(AVD::Constraints::NotBlank::IS_BLANK_ERROR)
      .assert_violation
  end

  private def create_validator : AVD::ConstraintValidatorInterface
    AVD::Constraints::NotBlank::Validator.new
  end

  private def constraint_class : AVD::Constraint.class
    AVD::Constraints::NotBlank
  end
end
