require "../spec_helper"

private def create_validator
  AVD::Constraints::CallbackValidator.new
end

describe AVD::Constraints::CallbackValidator do
  describe "#validate" do
    it "includes the value in static callbacks" do
      constraint = AVD::Constraints::Callback.with_callback do |container|
        value, context, payload = container.expand

        value.should eq "foo"
        context.should be_a AVD::ExecutionContextInterface
        payload.should be_nil
      end

      assert_no_violation(create_validator, constraint, "foo")
    end

    it "the value is nil in non static callbacks" do
      constraint = AVD::Constraints::Callback.with_callback(static: false) do |container|
        value, context, payload = container.expand

        value.should be_nil
        context.should be_a AVD::ExecutionContextInterface
        payload.should be_nil
      end

      assert_no_violation(create_validator, constraint, "foo")
    end

    it "does not run the callback if the value is nil" do
      constraint = AVD::Constraints::Callback.with_callback(static: false) do |container|
        container.context.add_violation "message"
      end

      assert_no_violation(create_validator, constraint, nil)
    end
  end
end
