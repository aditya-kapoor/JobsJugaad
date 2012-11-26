class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_user_locale

  private

  def set_user_locale
    I18n.locale = session['locale']
  end
end