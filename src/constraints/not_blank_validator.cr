struct Athena::Validator::Constraints::NotBlankValidator < Athena::Validator::ConstraintValidator
  # :inherit:
  def validate(value : String?, constraint : AVD::Constraints::NotBlank) : Nil
    validate_value(value, constraint) do |v|
      v.blank?
    end
  end

  # :inherit:
  def validate(value : Bool?, constraint : AVD::Constraints::NotBlank) : Nil
    validate_value(value, constraint) do |v|
      v == false
    end
  end

  # :inherit:
  def validate(value : Indexable?, constraint : AVD::Constraints::NotBlank) : Nil
    validate_value(value, constraint) do |v|
      v.empty?
    end
  end

  private def validate_value(value : _, constraint : AVD::Constraints::NotBlank, & : -> Bool) : Nil
    return if value.nil? && constraint.allow_nil?

    if value.nil? || yield value
      self.context
        .build_violation(constraint.message)
        .add_parameter("{{ value }}", value)
        .code(AVD::Constraints::NotBlank::IS_BLANK_ERROR)
        .add
    end
  end
end
