class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_cache_buster

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def current_employer
    @current_employer ||= Employer.find(session[:employer_id]) if session[:employer_id]
  end

  def current_user
    @current_job_seeker ||= JobSeeker.find(session[:job_seeker_id]) if session[:job_seeker_id]
  end

  helper_method :current_user
  helper_method :current_employer
end
