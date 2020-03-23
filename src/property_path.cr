module Athena::Validator::PropertyPath
  def self.append(base_path : String, sub_path : String) : String
    return base_path if sub_path.blank?

    return "#{base_path}#{sub_path}" if sub_path.starts_with? '['

    !base_path.blank? ? "#{base_path}.#{sub_path}" : sub_path
  end
end
