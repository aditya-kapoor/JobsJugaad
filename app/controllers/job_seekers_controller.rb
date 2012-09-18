class JobSeekersController < ApplicationController
  def index
  end

  def edit
    @job_seeker = JobSeeker.find(params[:id])
    @job_seeker.key_skills
  end

  def update
    @job_seeker = JobSeeker.find(params[:id])
    
    respond_to do |format|
      if @job_seeker.update_attributes(params[:job_seeker])
        format.html { redirect_to profile_path, notice: 'Your profile has been successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @job_seeker.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @job_seeker = JobSeeker.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @job_seeker }
    end
  end

  def create
    @job_seeker = JobSeeker.new(params[:job_seeker])
    respond_to do |format|
      if @job_seeker.save
        format.html { redirect_to root_path, notice: 'Job Seeker Account was successfully created. Please login with your new credentials.' }
        format.json { render json: root_path, status: :created, location: @job_seeker }
      else
        format.html { render action: "new" }
        format.json { render json: @job_seeker.errors, status: :unprocessable_entity }
      end
    end
  end

  def change_password
    @job_seeker = JobSeeker.find(session[:id])
  end

  def update_password
    @job_seeker = JobSeeker.find(session[:id])
    if @job_seeker.authenticate(params[:old_password])
      if @job_seeker.update_attributes(params[:job_seeker])
        redirect_to profile_path, :notice => "Password has been changed successfully."
      else
        render "change_password.html.erb", :notice => "There Were Some Errors"
      end
    else
      redirect_to request.referrer, :notice => "Invalid Password"
    end
  end

  def profile
    # @job_seeker = JobSeeker.find()
  end

  def forgot_password
  end
end
