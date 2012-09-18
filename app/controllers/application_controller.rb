class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_cache_buster

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def current_user
    if session[:user_type] == 'job_seeker'
      @current_job_seeker ||= JobSeeker.find(session[:job_seeker_id])
    else
      @current_employer ||= Employer.find(session[:employer_id])
    end
  end
  helper_method :current_user
end
