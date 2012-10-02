module ApplicationHelper
  def error_present?(parameter, reference)
    reference.errors[parameter].empty?
  end

  def get_errors(parameter, reference)
    reference.errors[parameter].join(", ")
  end
  
  def is_image_missing?(url)
    if url.split("/").pop == "default.gif"
      false
    else
      true
    end
  end

  def is_admin?
    session[:id] && session[:user_type] == 'admin'
  end

  def current_admin
    if session[:id] && session[:user_type] == 'admin'
      @current_admin ||= Admin.find(session[:id])
    end
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
    case session[:user_type]
    when "job_seeker"
      :profile
    when "employer"
      :eprofile
    when "admin"
      :admin_profile
    end
  end

end
