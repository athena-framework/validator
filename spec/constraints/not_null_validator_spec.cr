require "../spec_helper"

private def create_validator
  AVD::Constraints::NotNullValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::NotNull.new **named_args
end

private VALID_VALUES = [
  {"", "string"},
  {true, "bool"},
  {false, "bool"},
  {0, "integer"},
  {Pointer(Void).null, "null pointer"},
]

describe AVD::Constraints::NotNullValidator do
  describe "#validate" do
    describe "valid values" do
      VALID_VALUES.each do |(actual, message)|
        it message do
          assert_constraint_validator create_validator, create_constraint do
            validate actual

            assert_no_violations
          end
        end
      end
    end

    describe "invalid values" do
      it Nil do
        assert_constraint_validator create_validator, create_constraint(message: "message") do
          validate nil

          build_violation("message")
            .add_parameter("{{ value }}", nil)
            .code(AVD::Constraints::NotNull::IS_NULL_ERROR)
            .assert_violation
        end
      end
    end
  end
end
