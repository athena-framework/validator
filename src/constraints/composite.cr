abstract class Athena::Validator::Constraints::Composite < Athena::Validator::Constraint
  getter constraints : Array(AVD::Constraint) = [] of AVD::Constraint

  def initialize(
    constraints : Array(AVD::Constraint) | AVD::Constraint,
    message : String,
    groups : Array(String) | String | Nil = nil,
    payload : Hash(String, String)? = nil
  )
    super message, groups, payload

    self.initialize_nested_constraints

    unless constraints.is_a? Array
      constraints = [constraints]
    end

    # TODO: Prevent `Valid` constraints

    if groups.nil?
      merged_groups = Hash(String, Bool).new

      constraints.each do |constraint|
        constraint.groups.each do |group|
          merged_groups[group] = true
        end
      end

      @groups = merged_groups.empty? ? [AVD::Constraint::DEFAULT_GROUP] : merged_groups.keys
      @constraints = constraints

      return
    end

    constraints.each do |constraint|
      # if !constraint.groups.nil?
      #   # TODO: Validate there are no excess groups
      # else
      constraint.groups = self.groups
      # end
    end

    @constraints = constraints
  end

  def add_implicit_group(group : String) : Nil
    super group

    @constraints.each &.add_implicit_group(group)
  end

  def initialize_nested_constraints : Nil
  end
end
