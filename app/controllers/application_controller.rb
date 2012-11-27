class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_user_locale
  before_filter :set_session_for_json_entries

  private

  def set_user_locale
    I18n.locale = session['locale']
  end

  def set_session_for_json_entries
    if params[:token].present?
      session[:user_type] = "employer"
      session[:id] = params[:emp_id]
    end
  end
end