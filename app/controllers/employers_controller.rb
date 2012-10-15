class EmployersController < ApplicationController

  before_filter :is_valid_access?, :except => [:new, :forgot_password, :show, :login]
  before_filter :is_valid_user?, :only => [:edit, :add_job, :update]
  before_filter :remove_params, :only => [:update]
  @@request_token = ""

  #FIXME_AB: authorize
  def is_valid_access?
    if session[:id].nil? 
      redirect_to root_path , :notice => "You are not currently logged into the system..."
    end
  end

  #FIXME_AB: authorize_user
  def is_valid_user?
    unless params[:id].to_s == session[:id].to_s && session[:user_type] == "employer"
      flash[:error] = "You are not authorised to do this"
      redirect_to root_url
    end
  end

  #FIXME_AB: Why? why don't you protect this attribute
  def remove_params
    if params[:employer][:email].present?
      params[:employer].delete('email')
    end
  end

  #FIXME_AB: what if not found?
  def profile
    @employer = Employer.find(session[:id])
  end

  def edit
    @employer = Employer.find(params[:id])
  end

  def show
    @employer = Employer.find_by_id(params[:id])
    
    respond_to do |format|
      #FIXME_AB: Don't you think this if-else and redirect thing should go in before_filter.
      if(@employer)
        format.html
      else
        #FIXME_AB: No message for user.
        format.html { redirect_to root_url }
      end
    end
  end

  def update
    @employer = Employer.find(params[:id])

    respond_to do |format|
      if @employer.update_attributes(params[:employer])
        format.html { redirect_to eprofile_url, notice: "Employer Profile was successfully updated." }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def remove_photo
    @employer = Employer.find(session[:id])
    @employer.photo.destroy
    @employer.update_attribute(:photo, nil)
    redirect_to eprofile_path
  end

  def new
    #FIXME_AB: Use proper variable names
    @class_object = Employer.new
  end

  def call_for_interview
    @employer = Employer.find(session[:id])
    @job_seeker = JobSeeker.find(params[:id])
    @job = Job.find(params[:job_id])
    @job_application = JobApplication.find_by_job_seeker_id_and_job_id(@job_seeker.id, @job.id) 
    
  end

  def post_to_twitter
    @job = Job.find(params[:id])
    @employer = Employer.find_by_id(session[:id])
    @@request_token = @employer.generate_request_token
    @link = @@request_token.authorize_url
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

  def add_job
    @employer = Employer.find(session[:id])
    @job = @employer.jobs.build
  end
end
