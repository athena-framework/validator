struct Athena::Validator::Constraints::GreaterThanOrEqualValidator < Athena::Validator::Constraints::AbstractComparisonValidator
  # :inherit:
  def compare_values(actual : _, expected : _) : Bool
    return true if expected.nil?
    return false unless cmp = (actual <=> expected)

    cmp >= 0
  end

  # :inherit:
  def error_code : String
    AVD::Constraints::GreaterThanOrEqual::TOO_LOW_ERROR
  end
end
