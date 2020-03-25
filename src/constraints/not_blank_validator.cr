struct Athena::Validator::Constraints::NotBlankValidator < Athena::Validator::ConstraintValidator
  def validate(value : String?, constraint : AVD::Constraints::NotBlank) : Nil
    value = (va = value) && (normalizer = constraint.normalizer) ? normalizer.call(va) : value

    validate(value, constraint) do |v|
      v.blank?
    end
  end

  def validate(value : Bool?, constraint : AVD::Constraints::NotBlank) : Nil
    validate(value, constraint) do |v|
      v == false
    end
  end

  def validate(value : Indexable?, constraint : AVD::Constraints::NotBlank) : Nil
    validate(value, constraint) do |v|
      v.empty?
    end
  end

  private def validate(value : _, constraint : AVD::Constraints::NotBlank, & : -> Bool) : Nil
    return if value.nil? && constraint.allow_nil?

    if value.nil? || yield value
      self.context
        .build_violation(constraint.message)
        .add_parameter("{{ value }}", value.to_s)
        .code(AVD::Constraints::NotBlank::IS_BLANK_ERROR)
        .add
    end
  end
end
