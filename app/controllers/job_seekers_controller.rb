class JobSeekersController < ApplicationController
  
  
  before_filter :is_valid_access?, :except => [:new, :forgot_password, :autocomplete_skill_name]
  skip_before_filter :is_valid_access?
  # before_filter :is_authorised_access?, :on => [:edit]
  autocomplete :skill, :name
  def is_authorised_access?
    if params[:id] == session[:id]
      render "edit"
    else
      redirect_to request.referrer, :notice => "You are not authorised to edit this profile"
    end
  end

  def is_valid_access?
    if session[:id].nil? 
      redirect_to root_path , :notice => "You are not currently logged into the system..."      
    else
      if session['user_type'] == 'employer'
        unless employer_authorised_to_see_profile?
          redirect_to root_path, :notice => "You are not allowed to see this particular profile"
        end
      end
    end
  end

  def index
  end

  def show
    @job_seeker = JobSeeker.find(params[:id])
  end

  def edit
    if params[:id].to_s == session[:id].to_s
      @job_seeker = JobSeeker.find(params[:id])
    else
      redirect_to :profile, :notice => "You are not authorised to edit this profile"
    end
  end

  def update
    @job_seeker = JobSeeker.find(params[:id])
    
    respond_to do |format|
      if @job_seeker.update_attributes(params[:job_seeker])
        format.html { redirect_to profile_path, notice: 'Your profile has been successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def upload_photo
    @job_seeker = JobSeeker.find(session[:id])
    respond_to do |format|
      if @job_seeker.update_attributes(params[:job_seeker])
        format.html { redirect_to profile_path, :notice => "Your profile pic has been changed successfully" }
        format.js
      else
        format.html { redirect_to request.referrer, :notice => "There Was An Error" }
        format.js
      end
    end
  end

  def upload_resume
    @job_seeker = JobSeeker.find(session[:id])
    respond_to do |format|
      if @job_seeker.update_attributes(params[:job_seeker])
        format.html { redirect_to profile_path, :notice => "Resume has been added successfully" }
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
    @class_object = JobSeeker.new
  end

  def profile
    @job_seeker = JobSeeker.find_by_id(session[:id])
    apply_to_job_after_login
    if @job_seeker.nil?
      redirect_to root_path, :notice => "You have already logged out of the system"
    end
  end

  def apply_to_job_after_login
    unless session[:job_to_be_added].nil?
      @job_seeker = JobSeeker.find(session[:id])
      if authorized_ids(@job_seeker).include?(Integer(session[:job_to_be_added].id))
        session[:job_to_be_added] = nil
        redirect_to :profile, :notice => "You have already applied for this job"
      else
        @job_seeker.jobs << session[:job_to_be_added]
        session[:job_to_be_added] = nil
        redirect_to :profile, :notice => "You have successfully applied for this job"
      end
    end
  end
end
