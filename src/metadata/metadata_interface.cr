module Athena::Validator::Metadata::MetadataInterface
  abstract def cascading_strategy : AVD::Metadata::CascadingStrategy
  abstract def traversal_strategy : AVD::Metadata::TraversalStrategy
  abstract def constraints : Array(AVD::Constraint)
  abstract def find_constraints(group : String) : Array(AVD::Constraint)
  # abstract def class_name : AVD::Validatable?
  abstract def name : String?
end
