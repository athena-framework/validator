abstract struct Athena::Validator::Constraint
  DEFAULT_GROUP = "default"

  getter message : String
  getter groups : Array(String)

  # getter payload

  def initialize(@message : String, groups : Array(String)? = nil)
    @groups = groups || [DEFAULT_GROUP]
  end

  def add_implicit_group(group : String) : Nil
    if @groups.includes?(DEFAULT_GROUP) && !@groups.includes?(group)
      @groups << group
    end
  end

  def validator : AVD::ConstraintValidator.class
    {{"#{@type}Validator".id}}
  end

  def targets : AVD::ConstraintTarget
    AVD::ConstraintTarget::Property
  end
end
