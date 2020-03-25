struct Athena::Validator::Constraints::NotBlankValidator < Athena::Validator::ConstraintValidator
  def validate(value : String?, constraint : AVD::Constraints::NotBlank) : Nil
    value = (v = value) && (normalizer = constraint.normalizer) ? normalizer.call(v) : value

    validate(value, constraint) do
      value.nil? || value.blank?
    end
  end

  def validate(value : Bool?, constraint : AVD::Constraints::NotBlank) : Nil
    validate(value, constraint) do
      value.nil? || value == false
    end
  end

  def validate(value : Indexable?, constraint : AVD::Constraints::NotBlank) : Nil
    validate(value, constraint) do
      value.nil? || value.empty?
    end
  end

  private def validate(value : _, constraint : AVD::Constraints::NotBlank, & : -> Bool) : Nil
    return if value.nil? && constraint.allow_nil?
    return unless yield

    self.context
      .build_violation(constraint.message)
      .add_parameter("{{ value }}", value.to_s)
      .code(AVD::Constraints::NotBlank::IS_BLANK_ERROR)
      .add
  end
end
