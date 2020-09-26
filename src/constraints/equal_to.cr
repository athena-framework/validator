class Athena::Validator::Constraints::EqualTo(ValueType) < Athena::Validator::Constraint
  include Athena::Validator::Constraints::AbstractComparison(ValueType)

  NOT_EQUAL_ERROR = "47d83d11-15d5-4267-b469-1444f80fd169"

  @@error_names = {
    NOT_EQUAL_ERROR => "NOT_EQUAL_ERROR",
  }

  def default_error_message : String
    "This value should be equal to {{ compared_value }}."
  end

  struct Validator < Athena::Validator::Constraints::ComparisonValidator
    # :inherit:
    def compare_values(actual : _, expected : _) : Bool
      actual == expected
    end

    # :inherit:
    def error_code : String
      NOT_EQUAL_ERROR
    end
  end
end
