require "../spec_helper"

private def create_validator
  AVD::Constraints::LessThanValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::Negative.new **named_args
end

private def error_code : String
  AVD::Constraints::LessThan::TOO_HIGH_ERROR
end

private VALID_COMPARISONS = [
  {-1, 0, "negative integer"},
  {-5.5, 0, "negative float"},
  {nil, 0, "nil"},
]

private INVALID_COMPARISONS = [
  {0, 0, "zero"},
  {2, 0, "number"},
  {5.5, 0, "float"},
  {333, 0, "number"},
]

describe AVD::Constraints::LessThanValidator do
  define_comparison_spec false
end
