require "../spec_helper"

struct CallbackValidatorTest < AVD::Spec::ConstraintValidatorTestCase
  def test_callback : Nil
    constraint = AVD::Constraints::Callback.with_callback(payload: {"foo" => "bar"}) do |value, context, payload|
      value.should eq 123
      payload.should eq({"foo" => "bar"})

      context.add_violation("my_message")
    end

    self.validator.validate 123, constraint

    self.build_violation("my_message").assert_violation
  end

  private def create_validator : AVD::ConstraintValidatorInterface
    AVD::Constraints::Callback::Validator.new
  end

  private def constraint_class : AVD::Constraint.class
    AVD::Constraints::Callback
  end
end
