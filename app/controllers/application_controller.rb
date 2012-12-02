class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_user_locale
  before_filter :set_session_for_json_entries

  private

  def set_user_locale
    I18n.locale = params['locale']
  end

  def default_url_options(options = {})
    {:locale => I18n.locale }
  end

  def set_session_for_json_entries
    if params[:token].present?
      if params[:role] == "Employer"
        session[:user_type] = "employer"
        employer = Employer.find_by_apitoken(params[:token])
        session[:id] = employer.id
      else
        session[:user_type] = "job_seeker"
        job_seeker = JobSeeker.find_by_apitoken(params[:token])
        session[:id] = job_seeker.id
      end
    end
  end
end