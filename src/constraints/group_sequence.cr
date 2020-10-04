annotation Athena::Validator::Annotations::GroupSequence; end

struct Athena::Validator::Constraints::GroupSequence
  getter groups : Array(String | Array(String))

  def self.new(groups : Array(String))
    new groups.map &.as(String | Array(String))
  end

  def initialize(@groups : Array(String | Array(String))); end

  module Provider
    abstract def group_sequence : Array(String | Array(String)) | AVD::Constraints::GroupSequence
  end
end
