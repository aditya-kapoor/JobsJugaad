module ApplicationHelper
  def error_present?(parameter, reference)
    reference.errors[parameter].empty?
  end

  def get_errors(parameter, reference)
    reference.errors[parameter].join(", ")
  end
  
end
