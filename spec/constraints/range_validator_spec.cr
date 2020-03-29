require "../spec_helper"

private def create_validator
  AVD::Constraints::RangeValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::Range.new **named_args
end

private TEN_TO_TWENTY = [
  10.00001,
  19.99999,
  10,
  20,
  10.0,
  20.0,
  nil,
]

private LESS_THAN_TEN = [
  9.99999,
  5,
  1.0,
]

private MORE_THAN_TWENTY = [
  20.000001,
  21,
  30.0,
]

private TEN_TO_TWNENTIETH_APRIL_2020 = [
  Time.utc(2020, 4, 10),
  Time.utc(2020, 4, 15),
  Time.utc(2020, 4, 20),
]

private SOONER_THAN_TENTH_APRIL_2020 = [
  Time.utc(2019, 4, 20),
  Time.utc(2020, 4, 9),
]

private LATER_THAN_TWENTIETH_APRIL_2020 = [
  Time.utc(2020, 4, 21),
  Time.utc(2021, 4, 9),
]

describe AVD::Constraints::RangeValidator do
  describe "#validate" do
    describe "valid" do
      describe Number do
        TEN_TO_TWENTY.each do |v|
          it "min" do
            assert_constraint_validator create_validator, create_constraint(range: 10..) do
              validate v

              assert_no_violations
            end
          end

          it "max" do
            assert_constraint_validator create_validator, create_constraint(range: ..20) do
              validate v

              assert_no_violations
            end
          end

          it "min/max" do
            assert_constraint_validator create_validator, create_constraint(range: 10..20) do
              validate v

              assert_no_violations
            end
          end
        end
      end

      describe Time do
        TEN_TO_TWNENTIETH_APRIL_2020.each do |date|
          it "min" do
            assert_constraint_validator create_validator, create_constraint(range: Time.utc(2020, 4, 10)..) do
              validate date

              assert_no_violations
            end
          end

          it "max" do
            assert_constraint_validator create_validator, create_constraint(range: ..Time.utc(2020, 4, 20)) do
              validate date

              assert_no_violations
            end
          end

          it "min/max" do
            assert_constraint_validator create_validator, create_constraint(range: Time.utc(2020, 4, 10)..Time.utc(2020, 4, 20)) do
              validate date

              assert_no_violations
            end
          end
        end
      end
    end

    describe "invalid" do
      describe Number do
        LESS_THAN_TEN.each do |v|
          it "min" do
            assert_constraint_validator create_validator, create_constraint(range: 10.., min_message: "min_message") do
              validate v

              build_violation("min_message")
                .add_parameter("{{ value }}", v)
                .add_parameter("{{ limit }}", 10)
                .code(AVD::Constraints::Range::TOO_LOW_ERROR)
                .assert_violation
            end
          end
        end

        MORE_THAN_TWENTY.each do |v|
          it "max" do
            assert_constraint_validator create_validator, create_constraint(range: ..20, max_message: "max_message") do
              validate v

              build_violation("max_message")
                .add_parameter("{{ value }}", v)
                .add_parameter("{{ limit }}", 20)
                .code(AVD::Constraints::Range::TOO_HIGH_ERROR)
                .assert_violation
            end
          end
        end

        MORE_THAN_TWENTY.each do |v|
          it "min/max - max" do
            assert_constraint_validator create_validator, create_constraint(range: 10..20, not_in_range_message: "not_in_range_message") do
              validate v

              build_violation("not_in_range_message")
                .add_parameter("{{ value }}", v)
                .add_parameter("{{ min }}", 10)
                .add_parameter("{{ max }}", 20)
                .code(AVD::Constraints::Range::NOT_IN_RANGE_ERROR)
                .assert_violation
            end
          end
        end

        LESS_THAN_TEN.each do |v|
          it "min/max - min" do
            assert_constraint_validator create_validator, create_constraint(range: 10..20, not_in_range_message: "not_in_range_message") do
              validate v

              build_violation("not_in_range_message")
                .add_parameter("{{ value }}", v)
                .add_parameter("{{ min }}", 10)
                .add_parameter("{{ max }}", 20)
                .code(AVD::Constraints::Range::NOT_IN_RANGE_ERROR)
                .assert_violation
            end
          end
        end
      end

      describe Time do
        SOONER_THAN_TENTH_APRIL_2020.each do |date|
          it "min" do
            expected_date = Time.utc(2020, 4, 10)

            assert_constraint_validator create_validator, create_constraint(range: expected_date.., min_message: "min_message") do
              validate date

              build_violation("min_message")
                .add_parameter("{{ value }}", date)
                .add_parameter("{{ limit }}", expected_date)
                .code(AVD::Constraints::Range::TOO_LOW_ERROR)
                .assert_violation
            end
          end
        end

        LATER_THAN_TWENTIETH_APRIL_2020.each do |date|
          it "max" do
            expected_date = Time.utc(2020, 4, 20)

            assert_constraint_validator create_validator, create_constraint(range: ..expected_date, max_message: "max_message") do
              validate date

              build_violation("max_message")
                .add_parameter("{{ value }}", date)
                .add_parameter("{{ limit }}", expected_date)
                .code(AVD::Constraints::Range::TOO_HIGH_ERROR)
                .assert_violation
            end
          end
        end

        SOONER_THAN_TENTH_APRIL_2020.each do |date|
          it "min/max - min" do
            expected_begin_date = Time.utc(2020, 4, 10)
            expected_end_date = Time.utc(2020, 4, 20)

            assert_constraint_validator create_validator, create_constraint(range: expected_begin_date..expected_end_date, not_in_range_message: "not_in_range_message") do
              validate date

              build_violation("not_in_range_message")
                .add_parameter("{{ value }}", date)
                .add_parameter("{{ min }}", expected_begin_date)
                .add_parameter("{{ max }}", expected_end_date)
                .code(AVD::Constraints::Range::NOT_IN_RANGE_ERROR)
                .assert_violation
            end
          end
        end

        LATER_THAN_TWENTIETH_APRIL_2020.each do |date|
          it "min/max - max" do
            expected_begin_date = Time.utc(2020, 4, 10)
            expected_end_date = Time.utc(2020, 4, 20)

            assert_constraint_validator create_validator, create_constraint(range: expected_begin_date..expected_end_date, not_in_range_message: "not_in_range_message") do
              validate date

              build_violation("not_in_range_message")
                .add_parameter("{{ value }}", date)
                .add_parameter("{{ min }}", expected_begin_date)
                .add_parameter("{{ max }}", expected_end_date)
                .code(AVD::Constraints::Range::NOT_IN_RANGE_ERROR)
                .assert_violation
            end
          end
        end
      end

      it "non numeric/time" do
        assert_constraint_validator create_validator, create_constraint(range: 10..20, invalid_message: "invalid_message") do
          validate "FOO"

          build_violation("invalid_message")
            .add_parameter("{{ value }}", "FOO")
            .code(AVD::Constraints::Range::INVALID_VALUE_ERROR)
            .assert_violation
        end
      end
    end
  end
end
