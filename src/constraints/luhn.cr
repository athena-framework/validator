struct Athena::Validator::Constraints::Luhn < Athena::Validator::Constraint
  configure

  INVALID_VALUE_ERROR   = "b9038148-6eca-45f9-b032-bac0d775671b"
  CHECKSUM_FAILED_ERROR = "26296d06-6c24-4bc4-b562-ac8c2555140f"

  DEFAULT_ERROR_MESSAGE = "Invalid card number."

  initializer
end
