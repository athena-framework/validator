require "../spec_helper"

struct RecursiveValidatorTest < AVD::Spec::ValidatorTestCase
  def create_validator(metadata_factory : AVD::Metadata::MetadataFactoryInterface) : AVD::Validator::ValidatorInterface
    AVD::Validator::RecursiveValidator.new metadata_factory: metadata_factory
  end
end
