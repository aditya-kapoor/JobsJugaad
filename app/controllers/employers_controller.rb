require 'employers_controller_helper_function'
class EmployersController < ApplicationController
  include EmployersControllerHelperFunctions
  @@request_token = ""
  before_filter :is_logged_in?, :except => [:new, :forgot_password, :show, :login]
  before_filter :is_authorize_user?, :only => [:edit, :add_job, :update]
  before_filter :is_employer_found, :only => [:edit, :show, :update]
  before_filter :is_employer_exist_in_session, :only => [:profile, :remove_photo, :add_job, :post_to_twitter, :post_tweet]

  caches_action :show, :layout => false

  def index
    respond_to do |format|
      if params[:token].present?
        @jobs = Employer.includes(:jobs).find_by_apitoken(params[:token]).jobs
        format.json { render :json => @jobs }
      else
        format.json { flash[:error] = "No token present"; redirect_to root_url }
      end
    end
  end

  def profile
    @employer = Employer.find_by_id(session[:id])
  end

  def edit
    @employer = Employer.find_by_id(params[:id])
  end

  def show
    @employer = Employer.find_by_id(params[:id])
  end

  def get_api_token
    @employer = Employer.find(session["id"])
    @employer.apitoken = SecureRandom.urlsafe_base64
    @employer.save
    flash[:notice] = "Successfully created token : #{@employer.apitoken}"
    redirect_to eprofile_path
  end

  def update
    @employer = Employer.find_by_id(params[:id])
    expire_action :action => :show
    respond_to do |format|
      if @employer.update_attributes(params[:employer])
        format.html { redirect_to eprofile_url, notice: "Employer Profile was successfully updated." }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def remove_photo
    @employer = Employer.find_by_id(params[:id])
    @employer.photo.destroy
    @employer.update_attribute(:photo, nil)
    redirect_to eprofile_path
  end

  def new
    @employer = Employer.new
    respond_to do |format|
      format.html { render "new", :locals => { :@class_object => @employer } }
    end
  end

  def add_job
    @employer = Employer.find_by_id(session[:id])
    @job = @employer.jobs.build
  end

  def post_to_twitter
    @job = Job.find_by_id(params[:id])
    @employer = Employer.find_by_id(session[:id])
    token, secret = @employer.check_for_existing_tokens
    if token && secret
      @employer.configure_twitter(token, secret)
      update_tweet_on_timeline(@job.description)
      flash[:notice] = "Successfully Tweeted Job Posting"
      redirect_to eprofile_path
    else
      @@request_token = @employer.generate_request_token(post_tweet_job_url)
      redirect_to @@request_token.authorize_url
    end
  end

  def post_tweet
    @employer = Employer.find_by_id(session[:id])
    @job = Job.find_by_id(params[:id])

    access_token = @employer.generate_access_token(params[:oauth_verifier])
    token, secret = access_token.token, access_token.secret
    @employer.save_token(token, secret)
    @employer.configure_twitter(token, secret)
    update_tweet_on_timeline(@job.description)
    flash[:notice] = "Successfully Tweeted Job Posting"
    redirect_to eprofile_path
  end

  def destroy
    @employer = Employer.find_by_id(params[:id])
    @employer.destroy

    respond_to do |format|
      format.html { redirect_to request.referer, :notice => "Employer has been successfully removed" }
    end
  end

  private

  def is_logged_in?
    if session[:id].nil? 
      redirect_to root_path , :notice => "You are not currently logged into the system..."
    end
  end

  def is_authorize_user?
    unless params[:id].to_s == session[:id].to_s && session[:user_type] == "employer"
      flash[:error] = "You are not authorised to do this"
      redirect_to root_url
    end
  end

  def is_employer_found
    @employer = Employer.find_by_id(params[:id])
    unless @employer
      flash[:error] = "Employer not found"
      redirect_to root_url
    end
  end

  def is_employer_exist_in_session
    @employer = Employer.find_by_id(session[:id]) if session[:user_type] == "employer"
    unless @employer
      flash[:error] = "Employer not found"
      redirect_to root_url
    end
  end
end
