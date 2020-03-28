struct Athena::Validator::Constraints::LessThanOrEqualValidator < Athena::Validator::Constraints::AbstractComparisonValidator
  # :inherit:
  def compare_values(actual : _, expected : _) : Bool
    return true if expected.nil?

    AVD::Compare.lte actual, expected
  end

  # :inherit:
  def error_code : String
    AVD::Constraints::LessThanOrEqual::TOO_HIGH_ERROR
  end
end
