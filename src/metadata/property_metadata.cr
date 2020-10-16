require "./property_metadata_interface"

class Athena::Validator::Metadata::PropertyMetadata(EntityType) < Athena::Validator::Metadata::MemberMetadata(EntityType)
  protected def value(obj : EntityType)
    {% begin %}
      {% unless PropertyIdx == Nil %}
        obj.@{{EntityType.instance_vars[PropertyIdx].name.id}}
      {% else %}
        case @name
          {% for ivar in EntityType.instance_vars %}
            when {{ivar.name.stringify}} then obj.@{{ivar.id}}
          {% end %}
        else
          raise "BUG: Unknown property #{@name} within #{EntityType}"
        end
      {% end %}
    {% end %}
  end
end
