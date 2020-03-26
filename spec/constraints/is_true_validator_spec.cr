require "../spec_helper"

private def create_validator
  AVD::Constraints::IsTrueValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::IsTrue.new **named_args
end

describe AVD::Constraints::IsTrueValidator do
  describe "#validate" do
    describe "valid values" do
      it Nil do
        assert_no_violation create_validator, create_constraint, nil
      end

      it Bool do
        assert_no_violation create_validator, create_constraint, true
      end

      it String do
        assert_no_violation create_validator, create_constraint, ""
      end

      it Int32 do
        assert_no_violation create_validator, create_constraint, 0
      end
    end

    describe "invalid values" do
      it Bool do
        assert_violations create_validator, create_constraint, false
      end

      it Pointer do
        assert_violations create_validator, create_constraint, Pointer(Void).null
      end
    end
  end
end
