class Athena::Validator::Constraints::LessThan(ValueType) < Athena::Validator::Constraint
  include Athena::Validator::Constraints::AbstractComparison(ValueType)

  TOO_HIGH_ERROR = "d9fbedb3-c576-45b5-b4dc-996030349bbf"

  @@error_names = {
    TOO_HIGH_ERROR => "TOO_HIGH_ERROR",
  }

  def default_error_message : String
    "This value should be less than {{ compared_value }}."
  end

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
    def compare_values(actual : _, expected : _) : NoReturn
      # TODO: Support checking if arbitrarily typed values are actually comparable once `#responds_to?` supports it.
      self.raise_invalid_type actual, "Number | String | Time"
    end

    # :inherit:
    def error_code : String
      TOO_HIGH_ERROR
    end
  end
end
