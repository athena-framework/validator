require "../spec_helper"

private def create_validator
  AVD::Constraints::IsTrueValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::IsTrue.new **named_args
end

private VALID_VALUES = [
  {true, "bool"},
  {"", "string"},
  {0, "integer"},
  {nil, "nil"},
]

describe AVD::Constraints::IsTrueValidator do
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
      it "bool" do
        assert_constraint_validator create_validator, create_constraint(message: "message") do
          validate false

          build_violation("message")
            .add_parameter("{{ value }}", false)
            .code(AVD::Constraints::IsTrue::NOT_TRUE_ERROR)
            .assert_violation
        end
      end

      it "null pointer" do
        assert_constraint_validator create_validator, create_constraint(message: "message") do
          actual = Pointer(Void).null

          validate actual

          build_violation("message")
            .add_parameter("{{ value }}", actual)
            .code(AVD::Constraints::IsTrue::NOT_TRUE_ERROR)
            .assert_violation
        end
      end
    end
  end
end
