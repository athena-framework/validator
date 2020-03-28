# struct Athena::Validator::Constraints::RangeValidator < Athena::Validator::ConstraintValidator
#   # :inherit:
#   def validate(value : _, constraint : AVD::Constraints::Range) : Nil
#     return if value.nil?

#     range = constraint.range

#     min = range.begin
#     max = range.end

#     max_cmp = max <=> value
#     min_cmp = min <=> value

#     if min && max && (max_cmp.try &.<(0) || min_cmp.try &.>(0))
#       self.context
#         .build_violation(constraint.not_in_range_message)
#         .add_parameter("{{ value }}", value)
#         .add_parameter("{{ min }}", min)
#         .add_parameter("{{ max }}", max)
#         .code(AVD::Constraints::Range::NOT_IN_RANGE_ERROR)
#         .add

#       return
#     end

#     if max && max_cmp.try &.< 0
#       self.context
#         .build_violation(constraint.max_message)
#         .add_parameter("{{ value }}", value)
#         .add_parameter("{{ limit }}", max)
#         .code(AVD::Constraints::Range::TOO_HIGH_ERROR)
#         .add

#       return
#     end

#     if min && min_cmp.try &.> 0
#       self.context
#         .build_violation(constraint.min_message)
#         .add_parameter("{{ value }}", value)
#         .add_parameter("{{ limit }}", min)
#         .code(AVD::Constraints::Range::TOO_LOW_ERROR)
#         .add

#       return
#     end
#   end
# end
