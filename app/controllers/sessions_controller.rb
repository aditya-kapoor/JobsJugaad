class SessionsController < ApplicationController

  def login
    if(params[:user_type] == 'job_seeker')
      @job_seeker = JobSeeker.find_by_email(params[:email])
      if @job_seeker && @job_seeker.authenticate(params[:password])
        session[:id] = @job_seeker.id
        session[:user_type] = 'job_seeker'
        redirect_to :profile
      else
        redirect_to request.referrer, :notice => "Invalid Email and Password Combination"
      end
    else
      @employer = Employer.find_by_email(params[:email])
      if @employer && @employer.authenticate(params[:password])
        session[:id] = @employer.id
        session[:user_type] = 'employer'
        redirect_to :eprofile
      else
        redirect_to request.referrer, :notice => "Invalid Email and Password Combination"
      end
    end
  end

  def destroy
    session[:id] = nil
    session[:user_type] = nil
    redirect_to root_url, :notice => "You have been logged out from all the pages of this website"
  end
end
