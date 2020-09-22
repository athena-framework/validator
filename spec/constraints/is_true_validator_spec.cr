require "../spec_helper"

struct IsTrueValidatorTest < AVD::Spec::ConstraintValidatorTestCase
  def test_nil_is_valid : Nil
    constraint = self.new_constraint

    self.validator.validate nil, constraint

    self.assert_no_violation
  end

  def test_true_is_valid : Nil
    constraint = self.new_constraint

    self.validator.validate true, constraint

    self.assert_no_violation
  end

  def test_false_is_invalid : Nil
    constraint = self.new_constraint message: "my_message"

    self.validator.validate false, constraint

    self.build_violation("my_message")
      .add_parameter("{{ value }}", false)
      .code(AVD::Constraints::IsTrue::NOT_TRUE_ERROR)
      .assert_violation
  end

  def test_one_is_invalid : Nil
    constraint = self.new_constraint message: "my_message"

    self.validator.validate 1, constraint

    self.build_violation("my_message")
      .add_parameter("{{ value }}", 1)
      .code(AVD::Constraints::IsTrue::NOT_TRUE_ERROR)
      .assert_violation
  end

  private def create_validator : AVD::ConstraintValidatorInterface
    AVD::Constraints::IsTrue::Validator.new
  end

  private def constraint_class : AVD::Constraint.class
    AVD::Constraints::IsTrue
  end
end
