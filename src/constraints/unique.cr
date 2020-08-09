struct Athena::Validator::Constraints::Unique < Athena::Validator::Constraint
  DEFAULT_ERROR_MESSAGE = "This collection should contain only unique elements."
  IS_NOT_UNIQUE         = "fd1f83d6-94b5-44bc-b39d-b1ff367ebfb8"

  initializer

  struct Validator < Athena::Validator::ConstraintValidator
    # :inherit:
    def validate(value : Indexable?, constraint : AVD::Constraints::Unique) : Nil
      return if value.nil?

      set = Set(typeof(value[0])).new value.size

      unless value.all? { |x| set.add?(x) }
        self.context
          .build_violation(constraint.message)
          .add_parameter("{{ value }}", value)
          .code(IS_NOT_UNIQUE)
          .add
      end
    end

    # :inherit:
    def compare_values(actual : _, expected : _) : Bool
      # TODO: Support checking if arbitrarily typed values are actually comparable once `#responds_to?` supports it.
      raise AVD::Exceptions::UnexpectedValueError.new actual, "Indexable"
    end
  end
end
