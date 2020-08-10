struct Athena::Validator::Constraints::GreaterThan(ValueType) < Athena::Validator::Constraint
  include Athena::Validator::Constraints::AbstractComparison(ValueType)

  DEFAULT_ERROR_MESSAGE = "This value should be greater than {{ compared_value }}."
  TOO_LOW_ERROR         = "a221096d-d125-44e8-a865-4270379ac11a"

  @@error_names = {
    TOO_LOW_ERROR => "TOO_LOW_ERROR",
  }

  struct Validator < Athena::Validator::Constraints::ComparisonValidator
    def compare_values(actual : Number, expected : Number) : Bool
      actual > expected
    end

    def compare_values(actual : String, expected : String) : Bool
      actual > expected
    end

    def compare_values(actual : Time, expected : Time) : Bool
      actual > expected
    end

    # :inherit:
    def compare_values(actual : _, expected : _) : Bool
      # TODO: Support checking if arbitrarily typed values are actually comparable once `#responds_to?` supports it.
      raise AVD::Exceptions::UnexpectedValueError.new actual, "Number | String | Time"
    end

    # :inherit:
    def error_code : String
      TOO_LOW_ERROR
    end
  end
end
