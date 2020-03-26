struct Athena::Validator::Constraints::NotEqualToValidator < Athena::Validator::Constraints::AbstractComparisonValidator
  # :inherit:
  def compare_values(expected : _, actual : _) : Bool
    expected != actual
  end

  # :inherit:
  def error_code : String
    AVD::Constraints::NotEqualTo::IS_EQUAL_ERROR
  end
end
