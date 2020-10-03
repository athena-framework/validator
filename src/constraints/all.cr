require "./composite"

class Athena::Validator::Constraints::All < Athena::Validator::Constraints::Composite
  def initialize(
    constraints : Array(AVD::Constraint) | AVD::Constraint,
    groups : Array(String) | String | Nil = nil,
    payload : Hash(String, String)? = nil
  )
    super constraints, "", groups, payload
  end

  struct Validator < Athena::Validator::ConstraintValidator
    include Basic

    # :inherit:
    def validate(value : Hash?, constraint : AVD::Constraints::All) : Nil
      return if value.nil?

      self.with_validator do |validator|
        value.each do |k, v|
          validator.at_path("[#{k}]").validate(v, constraint.constraints)
        end
      end
    end

    # :inherit:
    def validate(value : Indexable?, constraint : AVD::Constraints::All) : Nil
      return if value.nil?

      self.with_validator do |validator|
        value.each_with_index do |item, idx|
          validator.at_path("[#{idx}]").validate(item, constraint.constraints)
        end
      end
    end

    # :inherit:
    def validate(value : _, constraint : AVD::Constraints::All) : NoReturn
      self.raise_invalid_type value, "Hash | Indexable"
    end

    private def with_validator(& : AVD::Validator::ContextualValidatorInterface ->) : Nil
      yield self.context.validator.in_context self.context
    end
  end
end
