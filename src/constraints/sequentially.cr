class Athena::Validator::Constraints::Sequentially < Athena::Validator::Constraints::Composite
  def initialize(
    constraints : Array(AVD::Constraint) | AVD::Constraint,
    groups : Array(String) | String | Nil = nil,
    payload : Hash(String, String)? = nil
  )
    super constraints, "", groups, payload
  end

  struct Validator < Athena::Validator::ConstraintValidator
    include Basic

    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::Sequentially) : Nil
      validator = self.context.validator.in_context self.context

      origional_count = validator.violations.size

      constraint.constraints.each do |c|
        break if origional_count != validator.validate(value, c).violations.size
      end
    end
  end
end
