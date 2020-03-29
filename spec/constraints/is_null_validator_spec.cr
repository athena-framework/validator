require "../spec_helper"

private def create_validator
  AVD::Constraints::IsNullValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::IsNull.new **named_args
end

private INVALID_VALUES = [
  {"foo", "string"},
  {false, "bool"},
  {0, "integer"},
  {Pointer(Void).null, "null pointer"},
]

describe AVD::Constraints::IsNullValidator do
  describe "#validate" do
    describe "valid values" do
      it Nil do
        assert_constraint_validator create_validator, create_constraint do
          validate nil

          assert_no_violations
        end
      end
    end

    describe "invalid values" do
      INVALID_VALUES.each do |(actual, message)|
        it message do
          assert_constraint_validator create_validator, create_constraint(message: "message") do
            validate actual

            build_violation("message")
              .add_parameter("{{ value }}", actual)
              .code(AVD::Constraints::IsNull::NOT_NULL_ERROR)
              .assert_violation
          end
        end
      end
    end
  end
end
