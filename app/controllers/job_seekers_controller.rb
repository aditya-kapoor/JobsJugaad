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

  def remove_photo
    @job_seeker = JobSeeker.find(session[:id])
    @job_seeker.photo.destroy
    @job_seeker.update_attribute(:photo, nil)
    redirect_to profile_path
  end

  def new
    @job_seeker = JobSeeker.new
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
    # begin
    #   @job_seeker = JobSeeker.find(params[:id])
    # rescue ActiveRecord::RecordNotFound
    #   flash[:error] = "Not Authorised To View This Page"
    #   redirect_to root_url
    # else     
    #   # current_user.photo.url(:small) ||= '/assets/images/default-photo/default.gif';
    # end
  end

  def forgot_password
  end
end
