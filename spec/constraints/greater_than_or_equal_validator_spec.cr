require "../spec_helper"

private def create_validator
  AVD::Constraints::GreaterThanOrEqualValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::GreaterThanOrEqual.new **named_args
end

private VALID_COMPARISONS = [
  {2, 1, "numbers"},
  {2, 2, "equal numbers"},
  {"zzz", "aaa", "strings"},
  {"fff", "fff", "equal strings"},
  {ComparableMock.new(10), ComparableMock.new(5), "comparable types"},
  {ComparableMock.new(-10), ComparableMock.new(-10), "equal comparable types"},
  {Time.utc(2021, 4, 7), Time.utc(2020, 4, 7), "times"},
  {Time.utc(2020, 4, 7), Time.utc(2020, 4, 7), "equal times"},
  {1, nil, "nil"},
]

private INVALID_COMPARISONS = [
  {1, 2, "numbers"},
  {"aaa", "zzz", "strings"},
  {ComparableMock.new(5), ComparableMock.new(10), "comparable types"},
  {Time.utc(2020, 4, 8), Time.utc(2021, 4, 7), "times"},
]

describe AVD::Constraints::GreaterThanOrEqualValidator do
  define_comparison_spec
end
