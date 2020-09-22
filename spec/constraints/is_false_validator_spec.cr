require "../spec_helper"

struct IsFalseValidatorTest < AVD::Spec::ConstraintValidatorTestCase
  def test_nil_is_valid : Nil
    constraint = self.new_constraint

    self.validator.validate nil, constraint

    self.assert_no_violation
  end

  def test_false_is_valid : Nil
    constraint = self.new_constraint

    self.validator.validate false, constraint

    self.assert_no_violation
  end

  def test_true_is_invalid : Nil
    constraint = self.new_constraint message: "my_message"

    self.validator.validate true, constraint

    self.build_violation("my_message")
      .add_parameter("{{ value }}", true)
      .code(AVD::Constraints::IsFalse::NOT_FALSE_ERROR)
      .assert_violation
  end

  def test_zero_is_invalid : Nil
    constraint = self.new_constraint message: "my_message"

    self.validator.validate 0, constraint

    self.build_violation("my_message")
      .add_parameter("{{ value }}", 0)
      .code(AVD::Constraints::IsFalse::NOT_FALSE_ERROR)
      .assert_violation
  end

  private def create_validator : AVD::ConstraintValidatorInterface
    AVD::Constraints::IsFalse::Validator.new
  end

  private def constraint_class : AVD::Constraint.class
    AVD::Constraints::IsFalse
  end
end
