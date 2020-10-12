class Athena::Validator::Constraints::Unique < Athena::Validator::Constraint
  IS_NOT_UNIQUE_ERROR = "fd1f83d6-94b5-44bc-b39d-b1ff367ebfb8"

  @@error_names = {
    IS_NOT_UNIQUE_ERROR => "IS_NOT_UNIQUE_ERROR",
  }

  def initialize(
    message : String = "This collection should contain only unique elements.",
    groups : Array(String) | String | Nil = nil,
    payload : Hash(String, String)? = nil
  )
    super message, groups, payload
  end

  struct Validator < Athena::Validator::ConstraintValidator
    # :inherit:
    def validate(value : Indexable?, constraint : AVD::Constraints::Unique) : Nil
      return if value.nil?

      set = Set(typeof(value[0])).new value.size

      unless value.all? { |x| set.add?(x) }
        self.context.add_violation constraint.message, IS_NOT_UNIQUE_ERROR, value
      end
    end

    # :inherit:
    def compare_values(actual : _, expected : _) : NoReturn
      # TODO: Support checking if arbitrarily typed values are actually comparable once `#responds_to?` supports it.
      self.raise_invalid_type actual, "Indexable"
    end
  end
end
