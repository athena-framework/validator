require "./property_metadata_interface"

struct Athena::Validator::Metadata::PropertyMetadata(IvarType, EntityType)
  include Athena::Validator::Metadata::GenericMetadata
  include Athena::Validator::Metadata::PropertyMetadataInterface(IvarType)

  getter name : String

  def initialize(@name : String); end

  def get_value(obj : EntityType)
    {% begin %}
      case @name
        {% for column in EntityType.instance_vars %}
          when {{column.name.stringify}} then obj.@{{column.id}}
        {% end %}
      else
        raise "BUG: Unknown column #{@name} within #{EntityType}"
      end
    {% end %}
  end
end
