require 'job_seekers_helper_functions'
class JobSeekersController < ApplicationController

  include JobSeekersControllerHelperFunctions
  
  before_filter :is_valid_access?, :except => [:new, :forgot_password, :index, :update, :autocomplete_skill_name]
  # skip_before_filter :is_valid_access?
  before_filter :is_authorised_access?, :only => [:edit, :update]
  autocomplete :skill, :name

  def index
    respond_to do |format|
      if params[:token].present?
        @jobs = JobSeeker.includes(:jobs => :employer ).find_by_apitoken(params[:token]).jobs

        format.html { flash[:error] = "Only JSON Format Allowed"; redirect_to root_url }
        format.json { render :json => @jobs }
      else
        format.html { flash[:error] = "No token present"; redirect_to root_url }
        format.json { flash[:error] = "No token present"; redirect_to root_url }
      end
    end
  end

  def show
    @job_seeker = JobSeeker.find(params[:id])
  end

  def edit 
    @job_seeker = JobSeeker.find(params[:id])
  end

  def update
    @job_seeker = JobSeeker.find(params[:id])
    expire_fragment "JobSeeker-#{@job_seeker.id}"
    
    respond_to do |format|
      if @job_seeker.update_attributes(params[:job_seeker])
        format.html { redirect_to profile_path, notice: 'Your profile has been successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def upload_asset
    @job_seeker = JobSeeker.find(session[:id])
    respond_to do |format|
      if @job_seeker.update_attributes(params[:job_seeker])
        format.html { redirect_to profile_path, 
                      :notice => "Your profile has been changed successfully" }
        format.js
      else
        format.html { redirect_to request.referrer, :notice => "There Was An Error" }
        format.js
      end
    end
  end

  def remove_photo
    @job_seeker = JobSeeker.find(session[:id])
    @job_seeker.photo.destroy
    @job_seeker.update_attribute(:photo, nil)
    redirect_to profile_path
  end

  def new
    @job_seeker = JobSeeker.new
    respond_to do |format|
      format.html { render "new", :locals => { :@class_object => @job_seeker } }

    end
  end

  def profile
    @job_seeker = JobSeeker.includes(:jobs => :employer).find_by_id(session[:id])
    apply_to_job_after_login
    if @job_seeker.nil?
      redirect_to root_path, :notice => "You have already logged out of the system"
    end
  end

  def download_resume
    @job_seeker = JobSeeker.find(params[:id])
    send_file(@job_seeker.resume.path.to_s, :type => @job_seeker.resume.content_type)
  end

  def get_api_token
    @job_seeker = JobSeeker.find(session["id"])
    @job_seeker.apitoken = SecureRandom.urlsafe_base64
    @job_seeker.save
    expire_fragment "JobSeeker-#{@job_seeker.id}"
    flash[:notice] = "Successfully created token : #{@job_seeker.apitoken}"
    redirect_to profile_path
  end

  private

  def is_authorised_access?
    unless params[:id].to_s == session[:id].to_s && session[:user_type] == "job_seeker"
      redirect_to root_url, :notice => "You are not authorised to edit this profile"
    end
  end

  def is_valid_access?
    if session[:id].nil? 
      redirect_to root_path , :notice => "You are not currently logged into the system..." 
    else
      if session['user_type'] == 'employer'
        check_if_employer_can_see_job_seeker_profile?
      end
    end
  end
end
