require "../spec_helper"

private def create_validator
  AVD::Constraints::BlankValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::Blank.new **named_args
end

describe AVD::Constraints::BlankValidator do
  describe "#validate" do
    describe "valid values" do
      it String do
        assert_no_violation create_validator, create_constraint, ""
      end

      it Nil do
        assert_no_violation create_validator, create_constraint, nil
      end
    end

    describe "invalid values" do
      it String do
        assert_violations create_validator, create_constraint, "foo"
      end

      it Bool do
        assert_violations create_validator, create_constraint, false
      end

      it Int32 do
        assert_violations create_validator, create_constraint, 123
      end
    end
  end
end
