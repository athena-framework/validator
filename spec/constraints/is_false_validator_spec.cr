require "../spec_helper"

private def create_validator
  AVD::Constraints::IsFalseValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::IsFalse.new **named_args
end

describe AVD::Constraints::IsFalseValidator do
  describe "#validate" do
    describe "valid values" do
      it Bool do
        assert_no_violation create_validator, create_constraint, false
      end

      it Pointer do
        assert_no_violation create_validator, create_constraint, Pointer(Void).null
      end

      it Nil do
        assert_no_violation create_validator, create_constraint, nil
      end
    end

    describe "invalid values" do
      it Bool do
        assert_violations create_validator, create_constraint, true
      end

      it String do
        assert_violations create_validator, create_constraint, ""
      end

      it Int32 do
        assert_violations create_validator, create_constraint, 0
      end
    end
  end
end
