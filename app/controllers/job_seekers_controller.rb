class JobSeekersController < ApplicationController
  def index
  end

  def edit
    @job_seeker = JobSeeker.find(params[:id])
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

  def login
    @job_seeker = JobSeeker.find_by_email(params[:email])
    if @job_seeker && @job_seeker.authenticate(params[:password])
      session[:job_seeker_id] = @job_seeker.id
      redirect_to :profile
    else
      redirect_to request.referrer, :notice => "Invalid Email and Password Combination"
    end
  end

  def logout
    session[:job_seeker_id] = nil
    redirect_to root_url, :notice => "You have been successfully logged out"
  end

  def profile
    @job_seeker = JobSeeker.find()
  end

  def forgot_password
  end
end
