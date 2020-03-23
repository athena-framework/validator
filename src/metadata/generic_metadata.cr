require "./metadata_interface"

module Athena::Validator::Metadata::GenericMetadata
  include Athena::Validator::Metadata::MetadataInterface

  getter constraints : Array(AVD::Constraint) = [] of AVD::Constraint
  getter cascading_strategy : AVD::Metadata::CascadingStrategy = AVD::Metadata::CascadingStrategy::None
  getter traversal_strategy : AVD::Metadata::TraversalStrategy = AVD::Metadata::TraversalStrategy::None
  @constraints_by_group : Hash(String, Array(AVD::Constraint)) = {} of String => Array(AVD::Constraint)

  def add_constraint(constraint : Constraint) : AVD::Metadata::GenericMetadata
    if constraint.is_a?(AVD::Constraints::Valid) && constraint.groups.nil?
      @cascading_strategy = :cascade
      @traversal_strategy = constraint.traverse? ? AVD::Metadata::TraversalStrategy::Implicit : AVD::Metadata::TraversalStrategy::None

      return self
    end

    @constraints << constraint

    constraint.groups.each do |group|
      (@constraints_by_group[group] ||= Array(AVD::Constraint).new) << constraint
    end

    self
  end

  def add_constraints(constraints : Array(AVD::Constraint)) : AVD::Metadata::GenericMetadata
    constraints.each do |constraint|
      add_constraint constraint
    end

    self
  end

  def find_constraints(group : String) : Array(AVD::Constraint)
    @constraints_by_group[group]? || Array(AVD::Constraint).new
  end
end
