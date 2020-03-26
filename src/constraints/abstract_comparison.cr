abstract struct Athena::Validator::Constraints::AbstractComparison < Athena::Validator::Constraint
  DEFAULT_ERROR_MESSAGE = ""

  @value_container : AVD::Container

  def initialize(
    value : _,
    message : String = DEFAULT_ERROR_MESSAGE,
    groups : Array(String)? = nil,
    payload : Hash(String, String)? = nil
  )
    @value_container = AVD::ValueContainer.new value

    super message, groups, payload
  end

  def value
    @value_container.value
  end

  def value_type
    @value_container.value_type
  end
end
