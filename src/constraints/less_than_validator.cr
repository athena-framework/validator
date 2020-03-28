struct Athena::Validator::Constraints::LessThanValidator < Athena::Validator::Constraints::AbstractComparisonValidator
  # :inherit:
  def compare_values(actual : _, expected : _) : Bool
    return true if expected.nil?
    return false unless cmp = (actual <=> expected)

    cmp < 0
  end

  # :inherit:
  def error_code : String
    AVD::Constraints::LessThan::TOO_HIGH_ERROR
  end
end
