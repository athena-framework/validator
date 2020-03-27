struct Athena::Validator::Constraints::EqualToValidator < Athena::Validator::Constraints::AbstractComparisonValidator
  # :inherit:
  def compare_values(actual : _, expected : _) : Bool
    actual == expected
  end

  # :inherit:
  def error_code : String
    AVD::Constraints::EqualTo::NOT_EQUAL_ERROR
  end
end
