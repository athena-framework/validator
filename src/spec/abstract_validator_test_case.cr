abstract struct Athena::Validator::Spec::AbstractValidatorTestCase < ASPEC::TestCase
  private class SubEntity
    include AVD::Validatable
  end

  private class Entity
    include AVD::Validatable

    property! first_name : String
    property! sub_object : SubEntity
    property! hash_sub_object : Hash(String, SubEntity)
  end

  @metadata : AVD::Metadata::ClassMetadataBase
  @sub_object_metadata : AVD::Metadata::ClassMetadataBase
  @metadata_factory : AVD::Spec::MockMetadataFactory

  def initialize
    @metadata = AVD::Metadata::ClassMetadata(Entity).new
    @sub_object_metadata = AVD::Metadata::ClassMetadata(SubEntity).new
    @metadata_factory = AVD::Spec::MockMetadataFactory.new
    @metadata_factory.add_metadata Entity, @metadata
    @metadata_factory.add_metadata SubEntity, @sub_object_metadata
  end

  abstract def validate(value : _, constraints, groups) : AVD::Violation::ConstraintViolationListInterface

  def test_validate : Nil
    callback = AVD::Constraints::Callback::CallbackProc.new do |value, context, _payload|
      context.class_name.should be_nil
      context.property_name.should be_nil
      context.property_path.should be_empty
      context.group.should eq "group"
      context.root.should eq "Fred"
      context.value.should eq "Fred"
      value.should eq "Fred"

      context.add_violation "message {{ value }}", {"{{ value }}" => "value"}
    end

    constraint = AVD::Constraints::Callback.new callback: callback, groups: ["group"]

    violations = self.validate "Fred", constraint, "group"

    violations.size.should eq 1

    violation = violations.first

    violation.message.should eq "message value"
    violation.message_template.should eq "message {{ value }}"
    violation.parameters.should eq({"{{ value }}" => "value"})
    violation.property_path.should be_empty
    violation.root.should eq "Fred"
    violation.invalid_value.should eq "Fred"
    violation.plural.should be_nil
    violation.code.should be_nil
  end

  def test_validate_class_constraint : Nil
    object = Entity.new

    callback = AVD::Constraints::Callback::CallbackProc.new do |value, context, _payload|
      context.class_name.should eq Entity
      context.property_name.should be_nil
      context.property_path.should be_empty
      context.group.should eq "group"
      context.root.should eq object
      context.value.should eq object
      value.should eq object

      context.add_violation "message {{ value }}", {"{{ value }}" => "value"}
    end

    @metadata.add_constraint AVD::Constraints::Callback.new callback: callback, groups: ["group"]

    violations = self.validate object, groups: "group"

    violations.size.should eq 1

    violation = violations.first

    violation.message.should eq "message value"
    violation.message_template.should eq "message {{ value }}"
    violation.parameters.should eq({"{{ value }}" => "value"})
    violation.property_path.should be_empty
    violation.root.should eq object
    violation.invalid_value.should eq object
    violation.plural.should be_nil
    violation.code.should be_nil
  end

  def test_validate_property_constraint : Nil
    object = Entity.new
    object.first_name = "Fred"

    callback = AVD::Constraints::Callback::CallbackProc.new do |value, context, _payload|
      property_metadata = @metadata.property_metadata "first_name"

      context.class_name.should eq Entity
      context.property_name.should eq "first_name"
      context.property_path.should eq "first_name"
      context.group.should eq "group"
      property_metadata.should eq context.metadata
      context.root.should eq object
      context.value.should eq "Fred"
      value.should eq "Fred"

      context.add_violation "message {{ value }}", {"{{ value }}" => "value"}
    end

    @metadata.add_property_constraint "first_name", AVD::Constraints::Callback.new callback: callback, groups: ["group"]

    violations = self.validate object, groups: "group"

    violations.size.should eq 1

    violation = violations.first

    violation.message.should eq "message value"
    violation.message_template.should eq "message {{ value }}"
    violation.parameters.should eq({"{{ value }}" => "value"})
    violation.property_path.should eq "first_name"
    violation.root.should eq object
    violation.invalid_value.should eq "Fred"
    violation.plural.should be_nil
    violation.code.should be_nil
  end

  def test_validate_object_in_hash : Nil
    object = Entity.new
    hash = {"key" => object}

    callback = AVD::Constraints::Callback::CallbackProc.new do |value, context, _payload|
      context.class_name.should eq Entity
      context.property_name.should be_nil
      context.property_path.should eq "[key]"
      context.group.should eq "group"
      context.metadata.should eq @metadata
      context.root.should eq hash
      context.value.should eq object
      value.should eq object

      context.add_violation "message {{ value }}", {"{{ value }}" => "value"}
    end

    @metadata.add_constraint AVD::Constraints::Callback.new callback: callback, groups: ["group"]

    violations = self.validate hash, groups: "group"

    violations.size.should eq 1

    violation = violations.first

    violation.message.should eq "message value"
    violation.message_template.should eq "message {{ value }}"
    violation.parameters.should eq({"{{ value }}" => "value"})
    violation.property_path.should eq "[key]"
    violation.root.should eq hash
    violation.invalid_value.should eq object
    violation.plural.should be_nil
    violation.code.should be_nil
  end

  def test_validate_object_in_nested_hash : Nil
    object = Entity.new
    hash = {2 => {"key" => object}}

    callback = AVD::Constraints::Callback::CallbackProc.new do |value, context, _payload|
      context.class_name.should eq Entity
      context.property_name.should be_nil
      context.property_path.should eq "[2][key]"
      context.group.should eq "group"
      context.metadata.should eq @metadata
      context.root.should eq hash
      context.value.should eq object
      value.should eq object

      context.add_violation "message {{ value }}", {"{{ value }}" => "value"}
    end

    @metadata.add_constraint AVD::Constraints::Callback.new callback: callback, groups: ["group"]

    violations = self.validate hash, groups: "group"

    violations.size.should eq 1

    violation = violations.first

    violation.message.should eq "message value"
    violation.message_template.should eq "message {{ value }}"
    violation.parameters.should eq({"{{ value }}" => "value"})
    violation.property_path.should eq "[2][key]"
    violation.root.should eq hash
    violation.invalid_value.should eq object
    violation.plural.should be_nil
    violation.code.should be_nil
  end

  def test_validate_ignores_null_sub_objects : Nil
    object = Entity.new

    @metadata.add_property_constraint "sub_object", AVD::Constraints::Valid.new

    self.validate(object).should be_empty
  end

  def test_validate_hash_sub_object : Nil
    object = Entity.new
    object.hash_sub_object = {"key" => SubEntity.new}

    callback = AVD::Constraints::Callback::CallbackProc.new do |value, context, _payload|
      context.class_name.should eq Entity
      context.property_name.should be_nil
      context.property_path.should eq "hash_sub_object[key]"
      context.group.should eq "group"
      context.metadata.should eq @metadata
      context.root.should eq object
      context.value.should eq object.hash_sub_object["key"]
      value.should eq object.hash_sub_object["key"]

      context.add_violation "message {{ value }}", {"{{ value }}" => "value"}
    end

    @metadata.add_property_constraint "hash_sub_object", AVD::Constraints::Valid.new
    @sub_object_metadata.add_constraint AVD::Constraints::Callback.new callback: callback, groups: ["group"]

    violations = self.validate object, groups: "group"

    violations.size.should eq 1

    violation = violations.first

    violation.message.should eq "message value"
    violation.message_template.should eq "message {{ value }}"
    violation.parameters.should eq({"{{ value }}" => "value"})
    violation.property_path.should eq "hash_sub_object[key]"
    violation.root.should eq object
    violation.invalid_value.should eq object.hash_sub_object["key"]
    violation.plural.should be_nil
    violation.code.should be_nil
  end
end
