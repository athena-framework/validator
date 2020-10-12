require "./composite"

class Athena::Validator::Constraints::AtLeastOneOf < Athena::Validator::Constraints::Composite
  DEFAULT_ERROR_MESSAGE = "This value should satisfy at least one of the following constraints:"
  AT_LEAST_ONE_OF_ERROR = "811994eb-b634-42f5-ae98-13eec66481b6"

  @@error_names = {
    AT_LEAST_ONE_OF_ERROR => "AT_LEAST_ONE_OF_ERROR",
  }

  getter include_internal_messages : Bool

  def initialize(
    constraints : Array(AVD::Constraint) | AVD::Constraint,
    @include_internal_messages : Bool = true,
    message : String = "This value should satisfy at least one of the following constraints:",
    groups : Array(String) | String | Nil = nil,
    payload : Hash(String, String)? = nil
  )
    super constraints, message, groups, payload
  end

  struct Validator < Athena::Validator::ConstraintValidator
    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::AtLeastOneOf) : Nil
      messages = [constraint.message]

      validator = self.context.validator

      constraint.constraints.each_with_index do |item, idx|
        violations = validator.validate value, [item]

        return if violations.empty?

        if constraint.include_internal_messages
          # TODO: Handle `All` and `Collection` constraints
          messages << " [#{idx + 1}] #{violations[0].message}"
        end
      end

      self.context.add_violation messages.join, AT_LEAST_ONE_OF_ERROR
    end
  end
end
