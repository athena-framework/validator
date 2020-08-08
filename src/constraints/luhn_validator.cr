struct Athena::Validator::Constraints::LuhnValidator < Athena::Validator::ConstraintValidator
  # :inherit:
  def validate(value : Number | String | Nil, constraint : AVD::Constraints::Luhn) : Nil
    return if value.nil? || value == ""

    value = value.to_s

    characters : Array(Char) = value.chars

    unless characters.all? &.number?
      self.context
        .build_violation(constraint.message)
        .add_parameter("{{ value }}", value)
        .code(AVD::Constraints::Luhn::INVALID_VALUE_ERROR)
        .add

      return
    end

    last_dig : Int32 = characters.pop.to_i
    checksum : Int32 = (characters.reverse.map_with_index { |n, idx| val = idx.even? ? n.to_i * 2 : n.to_i; val -= 9 if val > 9; val }.sum + last_dig)

    if checksum.zero? || !checksum.divisible_by? 10
      self.context
        .build_violation(constraint.message)
        .add_parameter("{{ value }}", value)
        .code(AVD::Constraints::Luhn::CHECKSUM_FAILED_ERROR)
        .add
    end
  end

  # :inherit:
  def validate(value : _, constraint : AVD::Constraints::Luhn) : Nil
    raise AVD::Exceptions::UnexpectedValueError.new value, "Number or String"
  end
end
