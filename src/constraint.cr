abstract struct Athena::Validator::Constraint
  DEFAULT_GROUP = "default"

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

  macro configure(**named_args)
    {% annotation_name = named_args[:annotation] || %(Athena::Validator::Annotations::#{@type.name.split("::").last.id}).id %}
    {% validator = named_args[:validator] || "#{@type}Validator".id %}
    {% targets = named_args[:targets] || ["property"] %}

    # The fully qualified name (FQN) of the annotation that should be related to `self`.
    #
    # Defaults to `self`'s class name within the `AVD::Annotations` namespace but can be overridden via the `AVD::Constraint.configure` macro.
    ANNOTATION = {{annotation_name}}

    # Denotes that possible targets `self` is allowed to be applied to.  Possible values are `"property"` or `"class"`.
    #
    # Defaults to `"property"`, but can be overridden via the `AVD::Constraint.configure` macro.
    TARGETS = {{targets}}

    # The `AVD::ConstraintValidator.class` that should be used to validate `self`.
    #
    # Defaults to `self`'s class name suffixed with "Validator", but can be overridden via the `AVD::Constraint.configure` macro.
    VALIDATOR = {{validator}}
    annotation ::{{annotation_name}}; end
  end

  # Builds the constraint initializer for `self` with the provided *message* and additional *properties*.
  #
  # Handles setting the default arguments and calling super.
  # ```
  # initializer("Some error message.", required_argument : String, optional_argument : Bool = false)
  # # def initialize(
  # #   @some_bool : Bool = false,
  # #   message : String = "Some error message.",
  # #   groups : Array(String)? = nil,
  # #   payload : Hash(String, String)? = nil
  # # )
  # #   super message, groups, payload
  # # end
  # ```
  macro initializer(message, *properties)
    def initialize(
      {% for property in properties %}
        @{{property}},
      {% end %}
      message : String = {{message}},
      groups : Array(String)? = nil,
      payload : Hash(String, String)? = nil,
    )
      super message, groups, payload
    end
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

        # Returns the `AVD::ConstraintValidator.class` that should be used to validate `self`.
        #
        # Defaults to `self`'s class name suffixed with "Validator", but can
        # be overridden in order to specify a custom type.
        def validator : AVD::ConstraintValidator.class
          VALIDATOR
        end
      {% end %}
    end
  end
end
