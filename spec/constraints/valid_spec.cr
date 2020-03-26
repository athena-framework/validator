require "../spec_helper"

private def create_constraint(**named_args)
  AVD::Constraints::Valid.new **named_args
end

describe AVD::Constraints::Valid do
  describe "#initialize" do
    it "uses default values" do
      create_constraint.traverse?.should be_true
    end

    it "allows changing the defaults" do
      create_constraint(traverse: false).traverse?.should be_false
    end
  end
end
