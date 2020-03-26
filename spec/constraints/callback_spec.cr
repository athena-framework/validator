require "../spec_helper"

private def create_constraint(**named_args)
  AVD::Constraints::Callback.new **named_args
end

describe AVD::Constraints::Callback do
  describe "#initialize" do
    it "uses default values" do
      constraint = AVD::Constraints::Callback.with_callback do
        nil
      end

      constraint.static?.should be_true
    end

    it "allows changing the defaults" do
      constraint = AVD::Constraints::Callback.with_callback(static: false) do
        nil
      end

      constraint.static?.should be_false
    end
  end
end
