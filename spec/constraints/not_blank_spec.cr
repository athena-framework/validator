require "../spec_helper"

private def create_constraint(**named_args)
  AVD::Constraints::NotBlank.new **named_args
end

describe AVD::Constraints::NotBlank do
  describe "#initialize" do
    it "uses default values" do
      constraint = create_constraint
      constraint.normalizer.should be_nil
      constraint.allow_nil?.should be_false
    end

    it "allows changing the defaults" do
      normalizer = ->(string : String) { string }

      constraint = create_constraint allow_nil: true, normalizer: normalizer
      constraint.normalizer.should eq normalizer
      constraint.allow_nil?.should be_true
    end
  end
end
