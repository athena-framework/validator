struct Athena::Validator::Constraints::EqualToValidator < Athena::Validator::Constraints::AbstractComparisonValidator
  # :inherit:
  def compare_values(expected : _, actual : _) : Bool
    expected == actual
  end

  # :inherit:
  def error_code : String
    AVD::Constraints::EqualTo::NOT_EQUAL_ERROR
  end
end
