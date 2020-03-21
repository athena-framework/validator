module Athena::Validator::Violation::ConstraintViolationListInterface
  abstract def add(violation : AVD::ConstraintViolationInterface) : Nil
  abstract def add(violations : AVD::ConstraintViolationListInterface) : Nil
  abstract def has(index : Int) : Bool
  abstract def set(index : Int, violation : AVD::ConstraintViolationInterface) : Nil
  abstract def remove(index : Int) : Nil
end
