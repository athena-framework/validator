struct Athena::Validator::Constraints::Callback < Athena::Validator::Constraint
  abstract struct Container
    abstract def value
    abstract def context : AVD::ExecutionContextInterface
    abstract def payload : Hash(String, String)?
  end

  record CallbackContainer(T) < Container, value : T, context : AVD::ExecutionContextInterface, payload : Hash(String, String)? do
    getter! value : T

    def expand
      {@value, @context, @payload}
    end
  end

  alias CallbackProc = Proc(AVD::Constraints::Callback::Container, Nil)

  macro with_callback(**named_args)
    callback = Proc(AVD::Constraints::Callback::Container, Nil).new do |container|
      {{yield}}

      nil
    end

    AVD::Constraints::Callback.new callback: callback, groups: {{named_args[:groups]}}, payload: {{named_args[:payload]}}
  end

  configure targets: ["property", "class"]

  getter callback : Proc(Container, Nil)
  getter? static : Bool

  initializer("", callback : Proc(Container, Nil), static : Bool = true)
end
