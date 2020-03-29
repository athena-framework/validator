require "../spec_helper"

private def create_validator
  AVD::Constraints::BlankValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::Blank.new **named_args
end

private VALID_VALUES = [
  {"", "string"},
  {nil, "nil"},
]

private INVALID_VALUES = [
  {"foo", "string"},
  {false, "bool"},
  {1232, "integer"},
]

describe AVD::Constraints::BlankValidator do
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
      INVALID_VALUES.each do |(actual, message)|
        it message do
          assert_constraint_validator create_validator, create_constraint(message: "message") do
            validate actual

            build_violation("message")
              .add_parameter("{{ value }}", actual)
              .code(AVD::Constraints::Blank::NOT_BLANK_ERROR)
              .assert_violation
          end
        end
      end
    end
  end
end
