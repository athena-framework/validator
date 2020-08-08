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

  protected abstract def default_error_message : String

  def add_implicit_group(group : String) : Nil
    if @groups.includes?(DEFAULT_GROUP) && !@groups.includes?(group)
      @groups << group
    end
  end

  macro inherited
    def validated_by : AVD::ConstraintValidator.class
      Validator
    end

    protected def default_error_message : String
      DEFAULT_ERROR_MESSAGE
    end
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
      message : String = default_error_message,
      groups : Array(String)? = nil,
      payload : Hash(String, String)? = nil,
    )
      super message, groups, payload
    end
  end
end
