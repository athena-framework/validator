struct Athena::Validator::Constraints::NotBlankValidator < Athena::Validator::ConstraintValidator
  def validate(value : _, constraint : AVD::Constraints::NotBlank) : Nil
    return if value.nil? && constraint.allow_nil?
    return if value == true

    # Break the logic down to make it easier to read
    is_blank = value.responds_to?(:blank?) && value.blank? # String
    is_empty = value.responds_to?(:empty?) && value.empty? # Arrays

    if value == false || is_blank || is_empty
      self.context
        .build(constraint.message)
        .add_parameter("{{ value }}", value.to_s)
        .code(AVD::Constraints::NotBlank::IS_BLANK_ERROR)
        .add
    end
  end
end
