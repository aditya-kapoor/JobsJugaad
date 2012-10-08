class AdminController < ApplicationController
  
  def index
  end

  def profile
    @admin = Admin.find_by_id(session[:id])
    @jobs = Job.all
    @job_seekers = JobSeeker.all
    @employers = Employer.all
  end

end
