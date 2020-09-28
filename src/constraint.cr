abstract class Athena::Validator::Constraint
  DEFAULT_GROUP = "default"

  @@error_names = Hash(String, String).new

  # Returns the name of the provided *error_code*.
  def self.error_name(error_code : String) : String
    @@error_names[error_code]? || raise KeyError.new "The error code '#{error_code}' does not exist for constraint of type '#{{{@type}}}'."
  end

  getter message : String
  property groups : Array(String)
  getter payload : Hash(String, String)?

  def initialize(@message : String, groups : Array(String)? = nil, @payload : Hash(String, String)? = nil)
    @groups = groups || [DEFAULT_GROUP]
  end

  def add_implicit_group(group : String) : Nil
    if @groups.includes?(DEFAULT_GROUP) && !@groups.includes?(group)
      @groups << group
    end
  end

  macro inherited
    {% unless @type.abstract? %}
      # See `{{@type.id}}`.
      annotation ::Athena::Validator::Annotations::{{@type.name(generic_args: false).split("::").last.id}}; end

      def validated_by : AVD::ConstraintValidator.class
        Validator
      end
    {% end %}
  end
end
