struct Athena::Validator::Constraints::GreaterThanValidator < Athena::Validator::Constraints::AbstractComparisonValidator
  # :inherit:
  def compare_values(actual : _, expected : _) : Bool
    return true if expected.nil?
    return false unless cmp = (actual <=> expected)

    cmp > 0
  end

  # :inherit:
  def error_code : String
    AVD::Constraints::GreaterThan::TOO_LOW_ERROR
  end
end
