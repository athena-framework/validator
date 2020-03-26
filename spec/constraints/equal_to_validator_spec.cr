require "../spec_helper"

private def create_validator
  AVD::Constraints::EqualToValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::EqualTo.new **named_args
end

VALID_COMPARISONS = [
  {1, 1, "numbers"},
  {"foo", "foo", "strings"},
  {ComparableMock.new(5), ComparableMock.new(5), "comparable types"},
  {Time.utc(2020, 4, 7), Time.utc(2020, 4, 7), "times"},
  {1, nil, "nil"},
]

INVALID_COMPARISONS = [
  {2, 1, "numbers"},
  {"bar", "foo", "strings"},
  {ComparableMock.new(10), ComparableMock.new(5), "comparable types"},
  {Time.utc(2020, 4, 8), Time.utc(2020, 4, 7), "times"},
]

describe AVD::Constraints::EqualToValidator do
  describe "#validate" do
    VALID_COMPARISONS.each do |(expected, actual, message)|
      it "valid #{message}" do
        assert_no_violation create_validator, create_constraint(value: expected), actual
      end
    end

    INVALID_COMPARISONS.each do |(expected, actual, message)|
      it "invalid #{message}" do
        assert_violations create_validator, create_constraint(value: expected), actual
      end
    end
  end
end

private record ComparableMock, value : Int32 do
  include Comparable(ComparableMock)

  def <=>(other : self) : Int32?
    @value <=> other.value
  end
end
