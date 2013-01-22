class ApplicationController < ActionController::Base
  protect_from_forgery
  # before_filter :set_user_locale
  # before_filter :set_session_for_json_entries

  private

  # def set_user_locale
  #   if params[:locale]
  #     session['locale'] = params[:locale]
  #     I18n.locale = session['locale']
  #   else
  #     I18n.locale = session['locale']
  #   end
  # end

  # def default_url_options(options = {})
  #   { :locale => session['locale'] || I18n.default_locale }
  # end

  def set_session_for_json_entries
    if params[:token].present?
      # user = params[:role].constantize.find_by_apitoken(params[:token])
      # session[:id] ||= user.id
      # session[:user_type] ||= params[:role].underscore
      case request.path
      when '/job_seekers.json'
        then
        user = JobSeeker.find_by_apitoken(params[:token])
        session[:id] = user.id
        session[:user_type] = "job_seeker"
        Rails.logger.info(request.path)
      when '/employers.json'
        then
        user = Employer.find_by_apitoken(params[:token])
        session[:id] = user.id
        session[:user_type] = "employer"
        Rails.logger.info(request.path)
      when /\/jobs(\/[\d]+)?.json/
        then
        user = Employer.find_by_apitoken(params[:token])
        session[:id] = user.id
        session[:user_type] = "employer"
      else
        flash[:error] = t('flash.error.security_breach')
        redirect_to root_path
      end
    end
  end
end