class Athena::Validator::Constraints::Valid < Athena::Validator::Constraint
  getter? traverse : Bool

  initializer(traverse : Bool = true)

  protected def default_error_message : String
    ""
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
