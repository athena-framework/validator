require "../spec_helper"

private def create_validator
  AVD::Constraints::NotEqualToValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::NotEqualTo.new **named_args
end

private VALID_COMPARISONS = [
  {2, 1, "numbers"},
  {"bar", "foo", "strings"},
  {ComparableMock.new(10), ComparableMock.new(5), "comparable types"},
  {Time.utc(2020, 4, 8), Time.utc(2020, 4, 7), "times"},
  {nil, 'a', "nil"},
]

private INVALID_COMPARISONS = [
  {1, 1, "numbers"},
  {"foo", "foo", "strings"},
  {ComparableMock.new(5), ComparableMock.new(5), "comparable types"},
  {Time.utc(2020, 4, 7), Time.utc(2020, 4, 7), "times"},
]

describe AVD::Constraints::NotEqualToValidator do
  define_comparison_spec
end
