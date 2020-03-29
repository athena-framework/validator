require "../spec_helper"

private def create_validator
  AVD::Constraints::LessThanOrEqualValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::NegativeOrZero.new **named_args
end

private def error_code : String
  AVD::Constraints::LessThanOrEqual::TOO_HIGH_ERROR
end

private VALID_COMPARISONS = [
  {0, 0, "zero"},
  {-1, 0, "negative integer"},
  {-5.5, 0, "negative float"},
  {nil, 0, "nil"},
]

private INVALID_COMPARISONS = [
  {2, 0, "number"},
  {5.5, 0, "float"},
  {333, 0, "number"},
]

describe AVD::Constraints::LessThanOrEqualValidator do
  define_comparison_spec false
end
