class EmployersController < ApplicationController

  before_filter :is_valid_access?, :except => [:new, :forgot_password, :show, :login]

  def is_valid_access?
    if session[:id].nil? 
      redirect_to root_path , :notice => "You are not currently logged into the system..."      
    end
  end

  def profile
    @employer = Employer.find(session[:id])
  end
  
  def edit
    if params[:id].to_s == session[:id].to_s
      @employer = Employer.find(params[:id])
    else
      redirect_to :eprofile, :notice => "You are not authorised to edit this profile"
    end
  end

  def show
    @employer = Employer.find_by_id(params[:id])
    
    respond_to do |format|
      if(@employer)
        format.html
      else
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
    @class_object = Employer.new
  end

  def call_for_interview
    @employer = Employer.find(session[:id])
    @job_seeker = JobSeeker.find(params[:id])
    @job = Job.find(params[:job_id])
    @job_application = JobApplication.find_by_job_seeker_id_and_job_id(@job_seeker.id, @job.id) 
    # Notifier.call_for_interview(@employer, @job_seeker, @job).deliver
  end

  def add_job
    @employer = Employer.find(session[:id])
    @job = @employer.jobs.build
  end

end
