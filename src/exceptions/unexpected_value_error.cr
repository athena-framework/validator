require "./validator_error"

class Athena::Validator::Exceptions::UnexpectedValueError < Athena::Validator::Exceptions::ValidatorError
  getter expected_type : String

  def initialize(value : _, @expected_type : String)
    super "Expected argument of type '#{expected_type}', '#{typeof(value)}' given."
  end
end
