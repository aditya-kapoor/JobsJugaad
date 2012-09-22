module ApplicationHelper
  def error_present?(parameter, reference)
    reference.errors[parameter].empty?
  end

  def get_errors(parameter, reference)
    reference.errors[parameter].join(", ")
  end
  
  def current_user
    if session[:id] && session[:user_type] == 'job_seeker'
      @current_job_seeker ||= JobSeeker.find(session[:id])
    elsif session[:id] && session[:user_type] == 'employer'
      # Don't use joins as it would generate an error
      @current_employer ||= Employer.includes(:jobs).find(session[:id])
    else
      nil
    end
  end

  def get_path
    if session[:user_type] == "job_seeker"
      :profile
    else
      :eprofile
    end
  end

end
