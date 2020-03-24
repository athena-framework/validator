struct Athena::Validator::Constraints::CallbackValidator < Athena::Validator::ConstraintValidator
  def validate(value : _, constraint : AVD::Constraints::Callback) : Nil
    return if value.nil?

    constraint.callback.call AVD::Constraints::Callback::CallbackContainer.new(constraint.static? ? value : nil, self.context, constraint.payload)
  end
end
