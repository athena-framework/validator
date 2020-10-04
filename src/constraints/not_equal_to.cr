class Athena::Validator::Constraints::NotEqualTo(ValueType) < Athena::Validator::Constraint
  include Athena::Validator::Constraints::AbstractComparison(ValueType)

  IS_EQUAL_ERROR = "984a0525-d73e-40c0-81c2-2ecbca7e4c96"

  @@error_names = {
    IS_EQUAL_ERROR => "IS_EQUAL_ERROR",
  }

  def default_error_message : String
    "This value should not be equal to {{ compared_value }}."
  end

  struct Validator < Athena::Validator::Constraints::ComparisonValidator
    # :inherit:
    def compare_values(actual : _, expected : _) : Bool
      actual != expected
    end

    # :inherit:
    def error_code : String
      IS_EQUAL_ERROR
    end
  end
end
