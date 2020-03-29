annotation Athena::Validator::RegisterConstraint; end

abstract struct Athena::Validator::Constraint
  DEFAULT_GROUP = "default"

  DEFAULT_ERROR_MESSAGE = ""

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
    {% begin %}
      {% annotation_name = named_args[:annotation] || %(Athena::Validator::Annotations::#{@type.name(generic_args: false).split("::").last.id}).id %}
      {% validator = named_args[:validator] || "#{@type.name(generic_args: false)}Validator".id %}
      {% targets = named_args[:targets] || ["property"] %}

      # The fully qualified name (FQN) of the annotation that should be related to `self`.
      #
      # Defaults to `self`'s class name within the `AVD::Annotations` namespace but can be overridden via the `AVD::Constraint.configure` macro.
      ANNOTATION = {{annotation_name}}

      # Denotes that possible targets `self` is allowed to be applied to.  Possible values are `"property"`, `"method"`, or `"class"`.
      #
      # Defaults to `"property"`, but can be overridden via the `AVD::Constraint.configure` macro.
      TARGETS = {{targets}}

      # The `AVD::ConstraintValidator.class` that should be used to validate `self`.
      #
      # Defaults to `self`'s class name suffixed with "Validator", but can be overridden via the `AVD::Constraint.configure` macro.
      VALIDATOR = {{validator}}

      # Annotation related to the `{{@type}}` constraint.
      annotation ::{{annotation_name}}; end

      @[Athena::Validator::RegisterConstraint(validator: {{validator}}, targets: {{targets}}, annotation: {{annotation_name}})]
      struct ::{{@type.name.id}}; end

      # Returns the `AVD::ConstraintValidator.class` that should be used to validate instances of `self`.
      #
      # Defaults to `self`'s class name suffixed with "Validator", but can
      # be overridden in order to specify a custom type.
      def self.validator : AVD::ConstraintValidator.class
        VALIDATOR
      end

      def self.targets : Array(String)
        TARGETS
      end

      def self.annotation
        ANNOTATION
      end
    {% end %}
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
  macro initializer(*properties)
    def initialize(
      {% for property in properties %}
        @{{property}},
      {% end %}
      message : String = DEFAULT_ERROR_MESSAGE,
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
      {% end %}
    end
  end
end
