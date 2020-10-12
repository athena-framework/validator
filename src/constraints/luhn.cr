class Athena::Validator::Constraints::Luhn < Athena::Validator::Constraint
  INVALID_CHARACTERS_ERROR = "c42b8d36-d9e9-4f5f-aad6-5190e27a1102"
  CHECKSUM_FAILED_ERROR    = "a4f089dd-fd63-4d50-ac30-34ed2a8dc9dd"

  @@error_names = {
    INVALID_CHARACTERS_ERROR => "INVALID_CHARACTERS_ERROR",
    CHECKSUM_FAILED_ERROR    => "CHECKSUM_FAILED_ERROR",
  }

  def initialize(
    message : String = "This value is not a valid credit card number.",
    groups : Array(String) | String | Nil = nil,
    payload : Hash(String, String)? = nil
  )
    super message, groups, payload
  end

  struct Validator < Athena::Validator::ConstraintValidator
    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::Luhn) : Nil
      value = value.to_s

      return if value.nil? || value.empty?

      characters = value.chars

      unless characters.all? &.number?
        return self.context.add_violation constraint.message, INVALID_CHARACTERS_ERROR, value
      end

      last_dig : Int32 = characters.pop.to_i
      checksum : Int32 = (characters.reverse.map_with_index { |n, idx| val = idx.even? ? n.to_i * 2 : n.to_i; val -= 9 if val > 9; val }.sum + last_dig)

      return if !checksum.zero? && checksum.divisible_by?(10)

      self.context.add_violation constraint.message, CHECKSUM_FAILED_ERROR, value
    end
  end
end
