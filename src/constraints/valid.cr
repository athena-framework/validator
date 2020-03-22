struct Athena::Validator::Constraints::Valid < Athena::Validator::Constraint
  getter? traverse : Bool

  def initialize(message : String = "", groups : Array(String)? = nil, payload : Hash(String, String)? = nil, @traverse : Bool = true)
    super message, groups, payload
  end
end
