class Athena::Validator::Constraints::Callback < Athena::Validator::Constraint
  abstract struct Value; end

  record ValueContainer(T) < Value, value : T do
    forward_missing_to @value

    def get(_t : T.class) : T forall T
      @value.as?(T).not_nil!
    end

    def ==(other) : Bool
      @value == other
    end
  end

  def self.with_callback(**args, &block : AVD::Constraints::Callback::Value, AVD::ExecutionContextInterface, Hash(String, String)? ->) : AVD::Constraints::Callback
    new **args, callback: block
  end

  alias CallbackProc = Proc(Value, AVD::ExecutionContextInterface, Hash(String, String)?, Nil)

  getter callback_name : String?
  getter callback : CallbackProc?

  def initialize(
    @callback_name : String? = nil,
    @callback : CallbackProc? = nil,
    groups : Array(String)? = nil,
    payload : Hash(String, String)? = nil
  )
    super "", groups, payload
  end

  struct Validator < Athena::Validator::ConstraintValidator
    include Basic

    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::Callback) : Nil
      return if value.nil?

      if value.is_a?(AVD::Validatable) && (name = constraint.callback_name) && (metadata = self.context.metadata) && (metadata.is_a?(AVD::Metadata::ClassMetadata))
        metadata.invoke_callback name, value, self.context, constraint.payload
      elsif callback = constraint.callback
        callback.call ValueContainer.new(value), self.context, constraint.payload
      end
    end
  end
end
