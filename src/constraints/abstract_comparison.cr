abstract struct Athena::Validator::Constraints::AbstractComparison < Athena::Validator::Constraint
  abstract def value
  abstract def value_type

  macro inherited
    getter value : ValueType
    getter value_type : ValueType.class = ValueType

    initializer(value : ValueType)
  end
end
