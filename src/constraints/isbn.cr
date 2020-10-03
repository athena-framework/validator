class Athena::Validator::Constraints::ISBN < Athena::Validator::Constraint
  enum Type
    ISBN10
    ISBN13
    Both

    def message(constraint : AVD::Constraints::ISBN) : String
      case self
      in .isbn10? then constraint.isbn10_message
      in .isbn13? then constraint.isbn13_message
      in .both?   then constraint.both_message
      end
    end
  end

  TOO_SHORT_ERROR           = "5da9e91f-7956-40f7-9788-4124463d783e"
  TOO_LONG_ERROR            = "ebd28c75-bb42-43d6-9053-f0ea2ea93d44"
  INVALID_CHARACTERS_ERROR  = "25d35907-d822-4bcc-82cc-852e30c89c0d"
  CHECKSUM_FAILED_ERROR     = "f51bae62-6833-43b1-bc27-ae4445c59e30"
  TYPE_NOT_RECOGNIZED_ERROR = "8d83f04d-2503-4547-97a1-935fcccd1ae1"

  @@error_names = {
    TOO_SHORT_ERROR           => "TOO_SHORT_ERROR",
    TOO_LONG_ERROR            => "TOO_LONG_ERROR",
    INVALID_CHARACTERS_ERROR  => "INVALID_CHARACTERS_ERROR",
    CHECKSUM_FAILED_ERROR     => "CHECKSUM_FAILED_ERROR",
    TYPE_NOT_RECOGNIZED_ERROR => "TYPE_NOT_RECOGNIZED_ERROR",
  }

  getter type : AVD::Constraints::ISBN::Type
  getter isbn10_message : String
  getter isbn13_message : String
  getter both_message : String

  def initialize(
    @type : AVD::Constraints::ISBN::Type = :both,
    @isbn10_message : String = "This value is not a valid ISBN-10.",
    @isbn13_message : String = "This value is not a valid ISBN-13.",
    @both_message : String = "This value is neither a valid ISBN-10 nor a valid ISBN-13.",
    groups : Array(String) | String | Nil = nil,
    payload : Hash(String, String)? = nil
  )
    super "", groups, payload
  end

  def message : String
    @type.message self
  end

  struct Validator < Athena::Validator::ConstraintValidator
    include Basic

    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::ISBN) : Nil
      value = value.to_s

      return if value.nil? || value.empty?

      canonical = value.gsub '-', ""

      code = case constraint.type
             in .isbn10? then self.validate_isbn10 canonical
             in .isbn13? then self.validate_isbn13 canonical
             in .both?
               both_code = self.validate_isbn10 canonical

               if TOO_LONG_ERROR == both_code
                 both_code = self.validate_isbn13 canonical

                 if TOO_SHORT_ERROR == both_code
                   both_code = TYPE_NOT_RECOGNIZED_ERROR
                 end
               end

               both_code
             end

      return if code.nil?

      self
        .context
        .build_violation(constraint.message, code, value)
        .add
    end

    private def validate_isbn10(isbn : String) : String?
      checksum = 0

      10.times do |idx|
        char = isbn.char_at(idx) { return TOO_SHORT_ERROR }

        digit = case char
                when 'X'      then 10
                when .number? then char.to_i
                else
                  return INVALID_CHARACTERS_ERROR
                end

        checksum += digit * (10 - idx)
      end

      return TOO_LONG_ERROR unless isbn[10]?.nil?

      checksum.divisible_by?(11) ? nil : CHECKSUM_FAILED_ERROR
    end

    private def validate_isbn13(isbn : String) : String?
      return INVALID_CHARACTERS_ERROR unless isbn.each_char.all? &.number?

      case isbn.size
      when .< 13 then return TOO_SHORT_ERROR
      when .> 13 then return TOO_LONG_ERROR
      end

      checksum = 0

      0.step(to: 12, by: 2) do |idx|
        checksum += isbn[idx].to_i
      end

      1.step(to: 12, by: 2) do |idx|
        checksum += isbn[idx].to_i * 3
      end

      checksum.divisible_by?(10) ? nil : CHECKSUM_FAILED_ERROR
    end
  end
end
