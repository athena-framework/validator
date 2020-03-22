abstract struct Athena::Validator::Constraint
  DEFAULT_GROUP = "default"

  # Denotes the the possible targets of `self`.
  #
  # Defaults to `property` but children can override it.  Possible options include `class`, and `property`.
  TARGETS = ["property"]

  # Returns the name of the provided *error_code*.
  def self.error_name(error_code : String) : String
    @@error_names[error_code]? || raise KeyError.new "The error code '#{error_code}' does not exist for constraint of type '#{{{@type}}}'."
  end

  getter message : String
  getter groups : Array(String)
  getter payload : Hash(String, String)?

  def initialize(@message : String, groups : Array(String)? = nil, @payload : Hash(String, String)? = nil)
    @groups = groups || [DEFAULT_GROUP]
  end

  def add_implicit_group(group : String) : Nil
    if @groups.includes?(DEFAULT_GROUP) && !@groups.includes?(group)
      @groups << group
    end
  end

  # Returns the `AVD::ConstraintValidator.class` that should be used to validate `self`.
  #
  # Defaults to `self`'s class name suffixed with "Validator", but can
  # be overridden in order to specify a custom type.
  def validator : AVD::ConstraintValidator.class
    {{"#{@type}Validator".id}}
  end

  macro inherited
    macro finished
      {% verbatim do %}
        {% begin %}
          {% errors = {} of Nil => Nil %}
          {% for error in @type.constants.select { |error| error =~ /ERROR$/ } %}
            {% errors[error] = error.stringify %}
          {% end %}
          @@error_names = {{errors}} of String => String
        {% end %}
      {% end %}
    end
  end
end
