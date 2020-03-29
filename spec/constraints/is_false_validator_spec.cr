require "../spec_helper"

private def create_validator
  AVD::Constraints::IsFalseValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::IsFalse.new **named_args
end

private VALID_VALUES = [
  {false, "bool"},
  {Pointer(Void).null, "null pointer"},
  {nil, "nil"},
]

private INVALID_VALUES = [
  {true, "bool"},
  {"", "string"},
  {0, "integer"},
]

describe AVD::Constraints::IsFalseValidator do
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
              .code(AVD::Constraints::IsFalse::NOT_FALSE_ERROR)
              .assert_violation
          end
        end
      end
    end
  end
end
