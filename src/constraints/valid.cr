class Athena::Validator::Constraints::Valid < Athena::Validator::Constraint
  getter? traverse : Bool

  def initialize(
    @traverse : Bool = true,
    groups : Array(String) | String | Nil = nil,
    payload : Hash(String, String)? = nil
  )
    super "", groups, payload
  end

  struct Validator < Athena::Validator::ConstraintValidator
    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::Valid) : Nil
      return if value.nil?

      self.context
        .validator
        .in_context(self.context)
        .validate value, groups: self.context.group
    end
  end
end
