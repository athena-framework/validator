require "../spec_helper"

class FooBarBaz
  include AVD::Validatable

  @[Assert::NotBlank(groups: ["nested"])]
  @foo : String? = nil
end

class FooBar
  include AVD::Validatable

  @[Assert::Valid(groups: ["nested"])]
  @foo_bar_baz : FooBarBaz = FooBarBaz.new
end

class Foo
  include AVD::Validatable

  @[Assert::Valid(groups: ["nested"])]
  @foo_bar : FooBar = FooBar.new
end

describe AVD::Constraints::Valid::Validator do
  it "should pass property paths to nested contexts" do
    validator = AVD.validator

    violations = validator.validate Foo.new, groups: "nested"

    violations.size.should eq 1
    violations[0].property_path.should eq "foo_bar.foo_bar_baz.foo"
  end
end
