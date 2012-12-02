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
      session[:user_type] = "employer"
      employer = Employer.find_by_apitoken(params[:token])
      session[:id] = employer.id
    end
  end
end