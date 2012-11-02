require 'employers_controller_helper_function'
class EmployersController < ApplicationController
  include EmployersControllerHelperFunctions

  before_filter :is_logged_in?, :except => [:new, :forgot_password, :show, :login]
  before_filter :is_authorize_user?, :only => [:edit, :add_job, :update]
  @@request_token = ""
  before_filter :is_employer_found, :only => [:edit, :show, :update]
  before_filter :is_employer_exist_in_session, :only => [:profile, :remove_photo, :call_for_interview, :add_job, :post_to_twitter, :post_tweet]

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
    @employer = Employer.find_by_id(session[:id])
    unless @employer
      flash[:error] = "Employer not found"
      redirect_to root_url
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

  def update
    @employer = Employer.find_by_id(params[:id])

    respond_to do |format|
      if @employer.update_attributes(params[:employer].except(:email))
        format.html { redirect_to eprofile_url, notice: "Employer Profile was successfully updated." }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def remove_photo
    @employer = Employer.find_by_id(session[:id])
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

  def call_for_interview
    @employer = Employer.find(session[:id])
    @job_seeker = JobSeeker.find(params[:id])
    @job = Job.find(params[:job_id])
    @job_application = JobApplication.find_by_job_seeker_id_and_job_id(@job_seeker.id, @job.id)     
  end

  def add_job
    @employer = Employer.find_by_id(session[:id])
    @job = @employer.jobs.build
  end

  def post_to_twitter
    @job = Job.find_by_id(params[:id])
    @employer = Employer.find_by_id(session[:id])
    @@request_token = @employer.generate_request_token(post_tweet_job_url)
    redirect_to @@request_token.authorize_url
  end

  def post_tweet
    @employer = Employer.find_by_id(session[:id])
    @job = Job.find_by_id(params[:id])
    oauth_verifier = params[:oauth_verifier]
    access_token = @@request_token.get_access_token(:oauth_verifier => oauth_verifier )
    token = access_token.token
    secret = access_token.secret
    @employer.configure_twitter(token, secret)
    Twitter.update(@job.description)
    flash[:notice] = "Successfully Tweeted Job Posting"
    redirect_to eprofile_path

  end

  def destroy
    @employer = Employer.find(params[:id])
    @employer.destroy

    respond_to do |format|
      format.html { redirect_to request.referer, :notice => "Employer has been successfully removed" }
    end
  end
end
