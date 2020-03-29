require "../spec_helper"

private def create_validator
  AVD::Constraints::NotBlankValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::NotBlank.new **named_args
end

private VALID_VALUES = [
  {"foo", "string"},
  {[1, 2, 3], "array"},
  {true, "bool"},
]

private INVALID_VALUES = [
  {nil, "nil"},
  {"", "string"},
  {false, "bool"},
  {[] of Int32, "empty array"},

]

describe AVD::Constraints::NotBlankValidator do
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

      describe "allow nil" do
        it Nil do
          assert_constraint_validator create_validator, create_constraint(allow_nil: true) do
            validate nil

            assert_no_violations
          end
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
              .code(AVD::Constraints::NotBlank::IS_BLANK_ERROR)
              .assert_violation
          end
        end
      end

      describe "allow nil" do
        it Bool do
          assert_constraint_validator create_validator, create_constraint(message: "message", allow_nil: true) do
            validate false

            build_violation("message")
              .add_parameter("{{ value }}", false)
              .code(AVD::Constraints::NotBlank::IS_BLANK_ERROR)
              .assert_violation
          end
        end
      end
    end
  end
end
