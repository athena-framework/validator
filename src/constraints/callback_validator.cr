struct Athena::Validator::Constraints::CallbackValidator < Athena::Validator::ConstraintValidator
  def validate(value : _, constraint : AVD::Constraints::Callback) : Nil
    return if value.nil?

    constraint.callback.call self.context, constraint.payload
  end
end
