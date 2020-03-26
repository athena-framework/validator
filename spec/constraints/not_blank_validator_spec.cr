require "../spec_helper"

private def create_validator
  AVD::Constraints::NotBlankValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::NotBlank.new **named_args
end

describe AVD::Constraints::NotBlankValidator do
  describe "#validate" do
    describe "valid values" do
      it String do
        assert_no_violation create_validator, create_constraint, "foo"
      end

      it Array do
        assert_no_violation create_validator, create_constraint, [1, 2, 3]
      end

      it Bool do
        assert_no_violation create_validator, create_constraint, true
      end

      describe "allow nil" do
        it Nil do
          assert_no_violation create_validator, create_constraint(allow_nil: true), nil
        end
      end
    end

    describe "invalid values" do
      it Nil do
        assert_violations create_validator, create_constraint, nil
      end

      it String do
        assert_violations create_validator, create_constraint, ""
      end

      it "normalizer" do
        proc = Proc(String, String).new do |str|
          str.strip
        end

        assert_violations create_validator, create_constraint(normalizer: proc), "\x20"
      end

      it Bool do
        assert_violations create_validator, create_constraint, false
      end

      it Array do
        assert_violations create_validator, create_constraint, [] of Int32
      end

      describe "allow nil" do
        it Bool do
          assert_violations create_validator, create_constraint(allow_nil: true), false
        end
      end
    end
  end
end
