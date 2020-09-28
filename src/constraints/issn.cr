class Athena::Validator::Constraints::ISSN < Athena::Validator::Constraint
  TOO_SHORT_ERROR          = "85c5d3aa-fd0a-4cd0-8cf7-e014e6379d59"
  TOO_LONG_ERROR           = "fab8e3ea-2f77-4da7-b40f-d9b24ff8c0cc"
  MISSING_HYPHEN_ERROR     = "d6c120a9-0b56-4e45-b4bc-7fd186f2cfbd"
  INVALID_CHARACTERS_ERROR = "85c5d3aa-fd0a-4cd0-8cf7-e014e6379d59"
  INVALID_CASE_ERROR       = "66f892f3-9eed-4176-b823-0dafde72202a"
  CHECKSUM_FAILED_ERROR    = "62c01bab-fe8f-4072-aac8-aa4bdcde8361"

  @@error_names = {
    TOO_SHORT_ERROR          => "TOO_SHORT_ERROR",
    TOO_LONG_ERROR           => "TOO_LONG_ERROR",
    MISSING_HYPHEN_ERROR     => "MISSING_HYPHEN_ERROR",
    INVALID_CHARACTERS_ERROR => "INVALID_CHARACTERS_ERROR",
    INVALID_CASE_ERROR       => "INVALID_CASE_ERROR",
    CHECKSUM_FAILED_ERROR    => "CHECKSUM_FAILED_ERROR",
  }

  getter? case_sensitive : Bool
  getter? require_hypen : Bool

  def initialize(
    @case_sensitive : Bool = false,
    @require_hypen : Bool = false,
    message : String = "This value is not a valid International Standard Serial Number (ISSN).",
    groups : Array(String)? = nil,
    payload : Hash(String, String)? = nil
  )
    super message, groups, payload
  end

  struct Validator < Athena::Validator::ConstraintValidator
    include Basic

    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::ISSN) : Nil
      value = value.to_s

      return if value.nil? || value.empty?

      canonical = value

      if canonical[4]? == '-'
        canonical = canonical.delete '-'
      elsif constraint.require_hypen?
        self.context
          .build_violation(constraint.message)
          .add_parameter("{{ value }}", value)
          .code(MISSING_HYPHEN_ERROR)
          .add

        return
      end

      size = canonical.size

      case size
      when .< 8
        self.context
          .build_violation(constraint.message)
          .add_parameter("{{ value }}", value)
          .code(TOO_SHORT_ERROR)
          .add

        return
      when .> 8
        self.context
          .build_violation(constraint.message)
          .add_parameter("{{ value }}", value)
          .code(TOO_LONG_ERROR)
          .add

        return
      end

      unless canonical[...7].each_char.all? &.number?
        self.context
          .build_violation(constraint.message)
          .add_parameter("{{ value }}", value)
          .code(INVALID_CHARACTERS_ERROR)
          .add

        return
      end

      if (char = canonical[7]) && !char.number? && !char.in? 'x', 'X'
        pp char
        self.context
          .build_violation(constraint.message)
          .add_parameter("{{ value }}", value)
          .code(INVALID_CHARACTERS_ERROR)
          .add

        return
      end

      if constraint.case_sensitive? && char == 'x'
        self.context
          .build_violation(constraint.message)
          .add_parameter("{{ value }}", value)
          .code(INVALID_CASE_ERROR)
          .add

        return
      end

      checksum = char.in?('x', 'X') ? 10 : char.to_i

      7.times do |idx|
        checksum += (8 - idx) * canonical[idx].to_i
      end

      return if checksum.divisible_by? 11

      self.context
        .build_violation(constraint.message)
        .add_parameter("{{ value }}", value)
        .code(CHECKSUM_FAILED_ERROR)
        .add
    end
  end
end
