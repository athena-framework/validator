struct Athena::Validator::Constraints::LessThan(ValueType) < Athena::Validator::Constraint
  include Athena::Validator::Constraints::AbstractComparison(ValueType)

  DEFAULT_ERROR_MESSAGE = "This value should be less than {{ compared_value }}."
  TOO_HIGH_ERROR        = "d9fbedb3-c576-45b5-b4dc-996030349bbf"

  struct Validator < Athena::Validator::Constraints::ComparisonValidator
    def compare_values(actual : Number, expected : Number) : Bool
      actual < expected
    end

    def compare_values(actual : String, expected : String) : Bool
      actual < expected
    end

    def compare_values(actual : Time, expected : Time) : Bool
      actual < expected
    end

    # :inherit:
    def compare_values(actual : _, expected : _) : Bool
      # TODO: Support checking if arbitrarily typed values are actually comparable once `#responds_to?` supports it.
      raise AVD::Exceptions::UnexpectedValueError.new actual, "Number | String | Time"
    end

    # :inherit:
    def error_code : String
      TOO_HIGH_ERROR
    end
  end
end
