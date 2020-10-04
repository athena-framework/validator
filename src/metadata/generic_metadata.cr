require "./metadata_interface"

module Athena::Validator::Metadata::GenericMetadata
  include Athena::Validator::Metadata::MetadataInterface

  getter constraints : Array(AVD::Constraint) = [] of AVD::Constraint
  getter cascading_strategy : AVD::Metadata::CascadingStrategy = AVD::Metadata::CascadingStrategy::None
  getter traversal_strategy : AVD::Metadata::TraversalStrategy = AVD::Metadata::TraversalStrategy::None
  @constraints_by_group = {} of String => Array(AVD::Constraint)

  def add_constraint(constraint : AVD::Constraint) : AVD::Metadata::GenericMetadata
    if constraint.is_a? AVD::Constraints::Valid
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
    constraints.each &->add_constraint(AVD::Constraint)

    self
  end

  def find_constraints(group : String) : Array(AVD::Constraint)
    @constraints_by_group[group]? || Array(AVD::Constraint).new
  end

  protected def get_value(entity : AVD::Validatable)
    raise "BUG: Invoked default get_value"
  end
end
