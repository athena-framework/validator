annotation Athena::Validator::Annotations::GroupSequence; end

record Athena::Validator::Constraints::GroupSequence, groups : Array(String) do
  module Provider
    abstract def group_sequence : Array(String)
  end
end
