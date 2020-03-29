require "../spec_helper"

private def create_validator
  AVD::Constraints::GreaterThanValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::Positive.new **named_args
end

private def error_code : String
  AVD::Constraints::GreaterThan::TOO_LOW_ERROR
end

private VALID_COMPARISONS = [
  {2, 0, "number"},
  {5.5, 0, "float"},
  {333, 0, "number"},
  {nil, 0, "nil"},
]

private INVALID_COMPARISONS = [
  {0, 0, "zero"},
  {-1, 0, "negative integer"},
  {-5.5, 0, "negative float"},
]

describe AVD::Constraints::GreaterThanValidator do
  define_comparison_spec false
end
