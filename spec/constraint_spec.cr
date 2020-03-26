require "./spec_helper"

describe AVD::Constraint do
  describe ".configure" do
    describe "defaults" do
      describe "ANNOTATION" do
        it "defaults to AVD::Annotations namespace" do
          Fake::DefaultConstraint::ANNOTATION.should eq Athena::Validator::Annotations::DefaultConstraint
        end

        it ".annotation" do
          Fake::DefaultConstraint.annotation.should eq Athena::Validator::Annotations::DefaultConstraint
        end
      end

      describe "VALIDATOR" do
        it "defaults to type name suffixed with Validator" do
          Fake::DefaultConstraint::VALIDATOR.should eq Fake::DefaultConstraintValidator
        end

        it ".validator" do
          Fake::DefaultConstraint.validator.should eq Fake::DefaultConstraintValidator
        end
      end

      describe "TARGETS" do
        it "defaults to property" do
          Fake::DefaultConstraint::TARGETS.should eq ["property"]
        end

        it ".targets" do
          Fake::DefaultConstraint.targets.should eq ["property"]
        end
      end
    end

    describe "custom" do
      describe "ANNOTATION" do
        it "uses what is provided" do
          CustomConstraint::ANNOTATION.should eq CustomConstraintAnotation
        end

        it ".targets" do
          CustomConstraint.annotation.should eq CustomConstraintAnotation
        end
      end

      describe "VALIDATOR" do
        it "uses what is provided" do
          CustomConstraint::VALIDATOR.should eq MyValidator
        end

        it ".targets" do
          CustomConstraint.validator.should eq MyValidator
        end
      end

      describe "TARGETS" do
        it "uses what is provided" do
          CustomConstraint::TARGETS.should eq ["foo"]
        end

        it ".targets" do
          CustomConstraint.targets.should eq ["foo"]
        end
      end
    end
  end

  describe ".error_name" do
    it "exists" do
      CustomConstraint.error_name("abc123").should eq "FAKE_ERROR"
    end

    it "does not add non _ERROR constants" do
      expect_raises(KeyError, "The error code 'BLAH' does not exist for constraint of type 'CustomConstraint'.") do
        CustomConstraint.error_name "BLAH"
      end
    end

    it "does not exist" do
      expect_raises(KeyError, "The error code 'foo' does not exist for constraint of type 'CustomConstraint'.") do
        CustomConstraint.error_name "foo"
      end
    end
  end

  describe "#add_implicit_group" do
    it "adds group when only group is default" do
      constraint = MockConstraint.new ""
      constraint.groups.should eq ["default"]
      constraint.add_implicit_group "foo"
      constraint.groups.should eq ["default", "foo"]
    end

    it "does not add when it's already included" do
      constraint = MockConstraint.new ""
      constraint.groups.should eq ["default"]
      constraint.add_implicit_group "foo"
      constraint.groups.should eq ["default", "foo"]
      constraint.add_implicit_group "foo"
      constraint.groups.should eq ["default", "foo"]
    end

    it "does not add when there are more than the default group" do
      constraint = MockConstraint.new "", groups: ["custom_group"]
      constraint.groups.should eq ["custom_group"]
      constraint.add_implicit_group "foo"
      constraint.groups.should eq ["custom_group"]
    end
  end

  describe "#initialize" do
    it "allows setting custom values" do
      constraint = CustomConstraint.new("MESSAGE", ["GROUP"], {"key" => "value"})
      constraint.message.should eq "MESSAGE"
      constraint.groups.should eq ["GROUP"]
      constraint.payload.should eq({"key" => "value"})
    end
  end
end
