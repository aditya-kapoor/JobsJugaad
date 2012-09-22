class JobSeekersController < ApplicationController
  
  before_filter :is_valid_access?, :except => [:new, :forgot_password]
  # before_filter :is_authorised_access?, :on => [:edit]

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
          redirect_to request.referrer, :notice => "You are not allowed to see this particular profile"
        end
      end
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

  def index
  end

  def show
    @job_seeker = JobSeeker.find(params[:id])
  end

  def edit
    if params[:id].to_s == session[:id].to_s
      @job_seeker = JobSeeker.find(params[:id])
      @job_seeker.key_skills
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

  def remove_photo
    @job_seeker = JobSeeker.find(session[:id])
    @job_seeker.photo.destroy
    @job_seeker.update_attribute(:photo, nil)
    redirect_to profile_path
  end

  def new
    @job_seeker = JobSeeker.new
  end

  def profile
    @job_seeker = JobSeeker.find(session[:id])
  end
end
