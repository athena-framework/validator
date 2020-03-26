require "../spec_helper"

private def create_validator
  AVD::Constraints::NotNullValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::NotNull.new **named_args
end

describe AVD::Constraints::NotNullValidator do
  describe "#validate" do
    describe "valid values" do
      it String do
        assert_no_violation create_validator, create_constraint, ""
      end

      it Bool do
        assert_no_violation create_validator, create_constraint, false
        assert_no_violation create_validator, create_constraint, true
      end

      it Int32 do
        assert_no_violation create_validator, create_constraint, 0
      end

      it Pointer do
        assert_no_violation create_validator, create_constraint, Pointer(Void).null
      end
    end

    describe "invalid values" do
      it Nil do
        assert_violations create_validator, create_constraint, nil
      end
    end
  end
end
