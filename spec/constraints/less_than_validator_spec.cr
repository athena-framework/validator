require "../spec_helper"

private def create_validator
  AVD::Constraints::LessThanValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::LessThan.new **named_args
end

private def error_code : String
  AVD::Constraints::LessThan::TOO_HIGH_ERROR
end

private VALID_COMPARISONS = [
  {1, 2, "numbers"},
  {"aaa", "zzz", "strings"},
  {ComparableMock.new(5), ComparableMock.new(10), "comparable types"},
  {Time.utc(2020, 4, 8), Time.utc(2021, 4, 7), "times"},
  {1, nil, "nil"},
]

private INVALID_COMPARISONS = [
  {2, 1, "numbers"},
  {"zzz", "aaa", "strings"},
  {ComparableMock.new(10), ComparableMock.new(5), "comparable types"},
  {Time.utc(2021, 4, 7), Time.utc(2020, 4, 7), "times"},
]

describe AVD::Constraints::LessThanValidator do
  define_comparison_spec
end
