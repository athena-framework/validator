require "./property_metadata_interface"

class Athena::Validator::Metadata::PropertyMetadata(T) < Athena::Validator::Metadata::GenericMetadata
  include Athena::Validator::Metadata::PropertyMetadataInterface(T)

  getter class_name : AVD::Validatable
  getter name : String

  def initialize(@value_proc : Proc(T), @class_name : AVD::Validatable, @name : String); end

  def value : T
    @value_proc.call
  end
end
