require "./property_metadata_interface"

class Athena::Validator::Metadata::PropertyMetadata(EntityType)
  include Athena::Validator::Metadata::GenericMetadata
  include Athena::Validator::Metadata::PropertyMetadataInterfaceBase

  # :inherit:
  getter name : String

  def initialize(@name : String); end

  # Returns the class the property `self` represents belongs to.
  def class_name : EntityType.class
    EntityType
  end

  protected def get_value(obj : EntityType)
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
