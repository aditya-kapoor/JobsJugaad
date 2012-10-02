class AuthenticationController < ApplicationController
  def index
    @authentications = Authentication.all
  end

  def create
    employer = Employer.find_by_id(session[:id])
    @auth_hash = request.env["omniauth.auth"].to_hash
    # employer.authentications.find_or_create_by_provider_and_uid(:provider => @auth_hash['provider'], :uid => @auth_hash['uid'])
    flash[:notice] = "Successfully Tweeted"
    employer.publish("This is the test tweet for the project", @auth_hash)
    # redirect_to root_url
  end
end
