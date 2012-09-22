class EmployersController < ApplicationController

  before_filter :is_valid_access?, :except => [:new, :forgot_password, :show, :login]

  def is_valid_access?
    if session[:id].nil? 
      redirect_to root_path , :notice => "You are not currently logged into the system..."      
    end
  end

  def employer_authorised_to_see_profile?
    authorized_ids = get_authorized_ids
    @employer = Employer.find(session[:id])
    @employer.jobs.each do |job|
      authorized_ids.concat(job.job_seekers.collect(&:id))
    end

    if(authorized_ids.include?(Integer(params["id"])))
      return true
    else 
      return false
    end
  end

  def get_authorized_ids
    authorized_ids = []
    @employer = Employer.find(session[:id])
    @employer.jobs.each do |job|
      authorized_ids.concat(job.job_seekers.collect(&:id))
    end
    authorized_ids
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
    @employer = Employer.find(params[:id])
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
    @employer = Employer.new
  end

  def add_job
    @employer = Employer.find(session[:id])
    @job = @employer.jobs.build
  end

end
