require "../spec_helper"

@[ASPEC::TestCase::Focus]
struct RecursiveValidatorTest < AVD::Spec::ValidatorTestCase
  def create_validator(metadata_factory : AVD::Metadata::MetadataFactoryInterface) : AVD::Validator::ValidatorInterface
    AVD::Validator::RecursiveValidator.new metadata_factory: metadata_factory
  end
end

# describe AVD::Validator::RecursiveValidator do
#   describe "#validate" do
#     it "validates" do
#       constraint = AVD::Constraints::Callback.with_callback(groups: ["group"]) do |value, context, _payload|
#         context.class_name.should be_nil
#         context.property_name.should be_nil
#         context.property_path.should be_empty
#         context.group.should eq "group"
#         context.root.should eq "foo"
#         context.value.should eq "foo"
#         value.should eq "foo"

#         context.add_violation "message {{ param }}", {"{{ param }}" => "value"}
#       end

#       violations = AVD.validator.validate "foo", [constraint], ["group"]

#       violations.size.should eq 1
#       violation = violations.first

#       violation.message.should eq "message value"
#       violation.message_template.should eq "message {{ param }}"
#       violation.parameters.should eq({"{{ param }}" => "value"})
#       violation.property_path.should be_empty
#       violation.root.should eq "foo"
#       violation.invalid_value.should eq "foo"
#       violation.plural.should be_nil
#       violation.code.should be_nil
#     end

#     it "validates class constraints" do
#       obj = TestClassCallback.new

#       TestClassCallback.class_callback = AVD::Constraints::Callback::CallbackProc.new do |value, context, _payload|
#         context.class_name.should eq TestClassCallback
#         context.property_name.should be_nil
#         context.property_path.should be_empty
#         context.group.should eq "group"
#         context.root.should eq obj
#         context.value.should eq obj
#         value.should eq obj

#         context.add_violation "message {{ param }}", {"{{ param }}" => "value"}
#       end

#       violations = AVD.validator.validate obj, groups: ["group"]

#       violations.size.should eq 1
#       violation = violations.first

#       violation.message.should eq "message value"
#       violation.message_template.should eq "message {{ param }}"
#       violation.parameters.should eq({"{{ param }}" => "value"})
#       violation.property_path.should be_empty
#       violation.root.should eq obj
#       violation.invalid_value.should eq obj
#       violation.plural.should be_nil
#       violation.code.should be_nil
#     end

#     it "validates property constraints" do
#       obj = TestPropertyCallback.new "Jim"

#       TestPropertyCallback.callback = AVD::Constraints::Callback::CallbackProc.new do |value, context, _payload|
#         context.class_name.should eq TestPropertyCallback
#         context.property_name.should eq "name"
#         context.property_path.should eq "name"
#         context.group.should eq "group"
#         context.root.should eq obj
#         context.value.should eq "Jim"
#         value.should eq "Jim"

#         context.add_violation "message {{ param }}", {"{{ param }}" => "value"}
#       end

#       violations = AVD.validator.validate obj, groups: ["group"]

#       violations.size.should eq 1
#       violation = violations.first

#       violation.message.should eq "message value"
#       violation.message_template.should eq "message {{ param }}"
#       violation.parameters.should eq({"{{ param }}" => "value"})
#       violation.property_path.should eq "name"
#       violation.root.should eq obj
#       violation.invalid_value.should eq "Jim"
#       violation.plural.should be_nil
#       violation.code.should be_nil
#     end

#     it Hash do
#       obj = TestClassCallback.new
#       hash = {"key" => obj}

#       TestClassCallback.class_callback = AVD::Constraints::Callback::CallbackProc.new do |value, context, _payload|
#         context.class_name.should eq TestClassCallback
#         context.property_name.should be_nil
#         context.property_path.should eq "[key]"
#         context.group.should eq "group"
#         context.root.should eq hash
#         context.value.should eq obj
#         value.should eq obj

#         context.add_violation "message {{ param }}", {"{{ param }}" => "value"}
#       end

#       violations = AVD.validator.validate hash, groups: ["group"]

#       violations.size.should eq 1
#       violation = violations.first

#       violation.message.should eq "message value"
#       violation.message_template.should eq "message {{ param }}"
#       violation.parameters.should eq({"{{ param }}" => "value"})
#       violation.property_path.should eq "[key]"
#       violation.root.should eq hash
#       violation.invalid_value.should eq obj
#       violation.plural.should be_nil
#       violation.code.should be_nil
#     end

#     it "recursive hash" do
#       obj = TestClassCallback.new
#       hash = {2 => {"key" => obj}}

#       TestClassCallback.class_callback = AVD::Constraints::Callback::CallbackProc.new do |value, context, _payload|
#         context.class_name.should eq TestClassCallback
#         context.property_name.should be_nil
#         context.property_path.should eq "[2][key]"
#         context.group.should eq "group"
#         context.root.should eq hash
#         context.value.should eq obj
#         value.should eq obj

#         context.add_violation "message {{ param }}", {"{{ param }}" => "value"}
#       end

#       violations = AVD.validator.validate hash, groups: ["group"]

#       violations.size.should eq 1
#       violation = violations.first

#       violation.message.should eq "message value"
#       violation.message_template.should eq "message {{ param }}"
#       violation.parameters.should eq({"{{ param }}" => "value"})
#       violation.property_path.should eq "[2][key]"
#       violation.root.should eq hash
#       violation.invalid_value.should eq obj
#       violation.plural.should be_nil
#       violation.code.should be_nil
#     end

#     it Array do
#       obj = TestClassCallback.new
#       arr = [obj]

#       TestClassCallback.class_callback = AVD::Constraints::Callback::CallbackProc.new do |value, context, _payload|
#         context.class_name.should eq TestClassCallback
#         context.property_name.should be_nil
#         context.property_path.should eq "[0]"
#         context.group.should eq "group"
#         context.root.should eq arr
#         context.value.should eq obj
#         value.should eq obj

#         context.add_violation "message {{ param }}", {"{{ param }}" => "value"}
#       end

#       violations = AVD.validator.validate arr, groups: ["group"]

#       violations.size.should eq 1
#       violation = violations.first

#       violation.message.should eq "message value"
#       violation.message_template.should eq "message {{ param }}"
#       violation.parameters.should eq({"{{ param }}" => "value"})
#       violation.property_path.should eq "[0]"
#       violation.root.should eq arr
#       violation.invalid_value.should eq obj
#       violation.plural.should be_nil
#       violation.code.should be_nil
#     end

#     it "recursive array" do
#       obj = TestClassCallback.new
#       arr = [[obj]]

#       TestClassCallback.class_callback = AVD::Constraints::Callback::CallbackProc.new do |value, context, _payload|
#         context.class_name.should eq TestClassCallback
#         context.property_name.should be_nil
#         context.property_path.should eq "[0][0]"
#         context.group.should eq "group"
#         context.root.should eq arr
#         context.value.should eq obj
#         value.should eq obj

#         context.add_violation "message {{ param }}", {"{{ param }}" => "value"}
#       end

#       violations = AVD.validator.validate arr, groups: ["group"]

#       violations.size.should eq 1
#       violation = violations.first

#       violation.message.should eq "message value"
#       violation.message_template.should eq "message {{ param }}"
#       violation.parameters.should eq({"{{ param }}" => "value"})
#       violation.property_path.should eq "[0][0]"
#       violation.root.should eq arr
#       violation.invalid_value.should eq obj
#       violation.plural.should be_nil
#       violation.code.should be_nil
#     end

#     it "validates single group" do
#       TestPropertyCallback.group2 = "group2"

#       TestPropertyCallback.callback = TestPropertyCallback.callback2 = AVD::Constraints::Callback::CallbackProc.new do |_value, context, _payload|
#         context.add_violation "message"
#       end

#       violations = AVD.validator.validate TestPropertyCallback.new("Jim", 2), groups: ["group"]

#       violations.size.should eq 1
#     end

#     it "validates multiple groups" do
#       TestPropertyCallback.group2 = "group2"
#       obj = TestPropertyCallback.new "Jim", 2

#       TestPropertyCallback.callback = TestPropertyCallback.callback2 = AVD::Constraints::Callback::CallbackProc.new do |_value, context, _payload|
#         context.add_violation "message"
#       end

#       violations = AVD.validator.validate obj, groups: ["group", "group2"]

#       violations.size.should eq 2
#     end

#     it "validates without group" do
#       AVD.validator.validate("", [AVD::Constraints::NotBlank.new]).should_not be_empty
#     end

#     it "validates empty constraints array" do
#       AVD.validator.validate("foo", [] of AVD::Constraint).should be_empty
#     end

#     it "validates custom violation" do
#       obj = TestClassCallback.new

#       TestClassCallback.group = nil

#       TestClassCallback.class_callback = AVD::Constraints::Callback::CallbackProc.new do |_value, context, _payload|
#         context.build_violation("message {{ param }}")
#           .add_parameter("{{ param }}", "value")
#           .plural(2)
#           .invalid_value("invalid_value")
#           .code("code")
#           .add
#       end

#       violations = AVD.validator.validate obj

#       violations.size.should eq 1
#       violation = violations.first

#       violation.message.should eq "message value"
#       violation.message_template.should eq "message {{ param }}"
#       violation.parameters.should eq({"{{ param }}" => "value"})
#       violation.property_path.should be_empty
#       violation.root.should eq obj
#       violation.invalid_value.should eq "invalid_value"
#       violation.plural.should eq 2
#       violation.code.should eq "code"
#     end

#     describe "group sequence" do
#       it "aborts after failed group" do
#         obj = TestClassCallback.new

#         TestClassCallback.group = ["group1"]
#         TestClassCallback.group2 = ["group2"]

#         TestClassCallback.class_callback = AVD::Constraints::Callback::CallbackProc.new do |_value, context, _payload|
#           pp "FOO"
#           context.add_violation "message1"
#         end

#         TestClassCallback.class_callback2 = AVD::Constraints::Callback::CallbackProc.new do |_value, context, _payload|
#           context.add_violation "message2"
#         end

#         sequence = AVD::Constraints::GroupSequence.new ["group1", "group2"]

#         violations = AVD.validator.validate obj, AVD::Constraints::Valid.new, sequence

#         violations.size.should eq 1
#         violations.first.message.should eq "message1"
#       end
#     end
#   end

#   describe "#validate_property" do
#     it "validates" do
#       obj = TestPropertyCallback.new "Jim", 2

#       TestPropertyCallback.callback = AVD::Constraints::Callback::CallbackProc.new do |value, context, _payload|
#         context.class_name.should eq TestPropertyCallback
#         context.property_name.should eq "name"
#         context.property_path.should eq "name"
#         context.group.should eq "group"
#         context.root.should eq obj
#         context.value.should eq "Jim"
#         value.should eq "Jim"

#         context.add_violation "message {{ param }}", {"{{ param }}" => "value"}
#       end

#       TestPropertyCallback.callback2 = AVD::Constraints::Callback::CallbackProc.new do |_value, context, _payload|
#         context.add_violation "violation"
#       end

#       violations = AVD.validator.validate_property obj, "name", groups: ["group"]

#       violations.size.should eq 1
#       violation = violations.first

#       violation.message.should eq "message value"
#       violation.message_template.should eq "message {{ param }}"
#       violation.parameters.should eq({"{{ param }}" => "value"})
#       violation.property_path.should eq "name"
#       violation.root.should eq obj
#       violation.invalid_value.should eq "Jim"
#       violation.plural.should be_nil
#       violation.code.should be_nil
#     end
#   end

#   describe "#validate_property_value" do
#     it "validates" do
#       obj = TestPropertyCallback.new "Fred", 2

#       TestPropertyCallback.callback = AVD::Constraints::Callback::CallbackProc.new do |value, context, _payload|
#         context.class_name.should eq TestPropertyCallback
#         context.property_name.should eq "name"
#         context.property_path.should eq "name"
#         context.group.should eq "group"
#         context.root.should eq obj
#         context.value.should eq "Jim"
#         value.should eq "Jim"

#         context.add_violation "message {{ param }}", {"{{ param }}" => "value"}
#       end

#       TestPropertyCallback.callback2 = AVD::Constraints::Callback::CallbackProc.new do |_value, context, _payload|
#         context.add_violation "violation"
#       end

#       violations = AVD.validator.validate_property_value obj, "name", "Jim", groups: ["group"]

#       violations.size.should eq 1
#       violation = violations.first

#       violation.message.should eq "message value"
#       violation.message_template.should eq "message {{ param }}"
#       violation.parameters.should eq({"{{ param }}" => "value"})
#       violation.property_path.should eq "name"
#       violation.root.should eq obj
#       violation.invalid_value.should eq "Jim"
#       violation.plural.should be_nil
#       violation.code.should be_nil
#     end
#   end
# end
