require "../spec_helper"

private def create_validator : AVD::Constraints::ValidValidator
  AVD::Constraints::ValidValidator.new
end

private def create_constraint(**named_args)
  AVD::Constraints::Valid.new **named_args
end

describe AVD::Constraints::ValidValidator do
  describe "#validate" do
    it "property paths are passed to nested contexts" do
      violations = AVD.validator.validate Foo.new, groups: ["nested"]

      violations.size.should eq 1
      violations.first.property_path.should eq "foo_bar.foo_bar_baz.str"
    end

    it "does not continue on nil" do
      obj = Foo.new
      obj.foo_bar = nil

      AVD.validator.validate(obj, groups: ["nested"]).should be_empty
    end
  end
end

private struct Foo
  include AVD::Validatable

  @[Assert::Valid(groups: ["nested"])]
  property foo_bar : FooBar? = FooBar.new
end

private struct FooBar
  include AVD::Validatable

  @[Assert::Valid(groups: ["nested"])]
  getter foo_bar_baz : FooBarBaz = FooBarBaz.new
end

private struct FooBarBaz
  include AVD::Validatable

  @[Assert::NotBlank(groups: ["nested"])]
  getter str : String = ""
end
