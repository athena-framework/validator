abstract class Athena::Validator::Metadata::MemberMetadata(MemberType) < Athena::Validator::Metadata::GenericMetadata
  include Athena::Validator::Metadata::PropertyMetadataInterface

  # :inherit:
  getter name : String

  def initialize(@name : String); end

  # Returns the class the member `self` represents, belongs to.
  def class_name : MemberType.class
    MemberType
  end
end
