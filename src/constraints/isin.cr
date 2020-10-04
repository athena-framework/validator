class Athena::Validator::Constraints::ISIN < Athena::Validator::Constraint
  VALIDATION_LENGTH  = 12
  VALIDATION_PATTERN = /[A-Z]{2}[A-Z0-9]{9}[0-9]{1}/

  INVALID_LENGTH_ERROR   = "1d1c3fbe-5b6f-42be-afa5-6840655865da"
  INVALID_PATTERN_ERROR  = "0b6ba8c4-b6aa-44dc-afac-a6f7a9a2556d"
  INVALID_CHECKSUM_ERROR = "c7d37ffb-0273-4f57-91f7-f47bf49aad08"

  @@error_names = {
    INVALID_LENGTH_ERROR   => "INVALID_LENGTH_ERROR",
    INVALID_PATTERN_ERROR  => "INVALID_PATTERN_ERROR",
    INVALID_CHECKSUM_ERROR => "INVALID_CHECKSUM_ERROR",
  }

  def initialize(
    message : String = "This value is not a valid International Securities Identification Number (ISIN).",
    groups : Array(String) | String | Nil = nil,
    payload : Hash(String, String)? = nil
  )
    super message, groups, payload
  end

  struct Validator < Athena::Validator::ConstraintValidator
    @validator : AVD::Validator::ValidatorInterface = AVD.validator

    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::ISIN) : Nil
      value = value.to_s

      return if value.nil? || value.empty?

      value = value.upcase

      if VALIDATION_LENGTH != value.size
        return self
          .context
          .build_violation(constraint.message, INVALID_LENGTH_ERROR, value)
          .add
      end

      unless value.matches? VALIDATION_PATTERN
        return self
          .context
          .build_violation(constraint.message, INVALID_PATTERN_ERROR, value)
          .add
      end

      return if self.is_correct_checksum value

      self
        .context
        .build_violation(constraint.message, INVALID_CHECKSUM_ERROR, value)
        .add
    end

    private def is_correct_checksum(isin : String) : Bool
      number = isin.chars.join { |char| char.to_i 36 }
      @validator.validate(number, AVD::Constraints::Luhn.new).empty?
    end
  end
end
