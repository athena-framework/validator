struct Athena::Validator::Constraints::ValidValidator < Athena::Validator::ConstraintValidator
  # :inherit:
  def validate(value : _, constraint : AVD::Constraints::Valid) : Nil
    return if value.nil?

    self.context.validator.in_context(self.context).validate value, groups: self.context.group.try { |g| [g] }
  end
end
