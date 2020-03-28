# struct Athena::Validator::Constraints::Range < Athena::Validator::Constraint
#   configure

#   getter not_in_range_message : String
#   getter min_message : String
#   getter max_message : String

#   NOT_IN_RANGE_ERROR = "7e62386d-30ae-4e7c-918f-1b7e571c6d69"
#   TOO_HIGH_ERROR     = "5d9aed01-ac49-4d8e-9c16-e4aab74ea774"
#   TOO_LOW_ERROR      = "f0316644-882e-4779-a404-ee7ac97ddecc"

#   def initialize(
#     @min : Float64? = nil,
#     @max : Float64? = nil,
#     @not_in_range_message : String = "This value should be between {{ min }} and {{ max }}.",
#     @min_message : String = "This value should be {{ limit }} or more.",
#     @max_message : String = "This value should be {{ limit }} or less.",
#     groups : Array(String)? = nil,
#     payload : Hash(String, String)? = nil
#   )
#     raise "Min or max must be supplied" if @min.nil? && @max.nil?

#     super "", groups, payload
#   end

#   def range
#     @min..@max
#   end
# end
