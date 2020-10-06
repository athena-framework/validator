abstract class Athena::Validator::Constraints::Compound < Athena::Validator::Constraints::Composite
  def initialize(
    groups : Array(String) | String | Nil = nil,
    payload : Hash(String, String)? = nil
  )
    super self.constraints, "", groups, payload
  end

  def validated_by : AVD::ConstraintValidator.class
    AVD::Constraints::Compound::Validator
  end

  abstract def constraints : Array(AVD::Constraint)

  struct Validator < Athena::Validator::ConstraintValidator
    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::Compound) : Nil
      context = self.context

      validator = context.validator.in_context context

      validator.validate value, constraint.constraints
    end
  end
end
