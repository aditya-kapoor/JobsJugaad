require_relative '../../lib/jobs_controller_helper_functions'
class JobsController < ApplicationController
    include JobsControllerHelperFunctions

  before_filter :check_for_valid_access, :only => [:view_applicants]
  before_filter :check_unauthorised_access, :only => [:edit, :create, :view_applicants]
  before_filter :check_for_session, :only => [:apply]

  @@rpp = 10
  def create
    @employer = Employer.find(session[:id])
    @job = @employer.jobs.build(params[:job])
    respond_to do |format|
      if @job.save
        format.html { redirect_to :eprofile, :notice => "A new job has been posted successfully" }
      else
        format.html { render :template => "employers/add_job", :notice => "Job Could not be saved" }
      end
    end
  end

  def check_unauthorised_access
    unless session[:user_type] == "employer"
      flash[:error] = "You are not authorised to do this"
      redirect_to root_url
    end
  end

  def check_for_valid_access
    employer = Employer.find_by_id(session[:id])
    if employer && session[:user_type] == "employer"
      unless employer.jobs.collect(&:id).include?(params[:id].to_i)
        flash[:error] = "Security Breach Detected"
        redirect_to root_url
      end
    else
      flash[:error] = "You are not logged in as employer"
      redirect_to root_url
    end
  end

  def check_for_session
    if session[:id].nil?
      session[:job_to_be_added] = Job.find_by_id(params[:job_id])
      redirect_to :root, :notice => "Please Login or Register as the job seeker"
    end
  end

  def edit
    @job = Job.find_by_id(params[:id])
  end

  def view_applicants
    @job = Job.find(params[:id])
  end

  def show
    @job = Job.find_by_id(params[:id])
  end

  def apply
    if session[:user_type] == "employer"
      redirect_to :root, :notice => "You are Logged in as employer. Please login as the Job Seeker"
    else
      apply_to_job
    end
  end

  def update
    @job = Job.find(params[:id])

    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.html { redirect_to :eprofile, notice: "Job was successfully updated." }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def search_results
    jobs_by_location = []
    jobs_by_skills = []
    jobs_by_salary = []
    selected_jobs = []

    unless params[:location].empty?
      jobs_by_location = return_jobs_by_location
    end

    unless params[:skills].empty?
      jobs_by_skills = return_jobs_by_skills
    end

    unless params[:sal_min].empty? && params[:sal_max].empty?
      jobs_by_salary = return_jobs_by_salary
    end

    temp_jobs = [jobs_by_location, jobs_by_skills, jobs_by_salary]

    temp_jobs.reject! { |x| x.empty? }
    
    selected_jobs = temp_jobs.inject { |a,b| a & b } if temp_jobs.any? 

    @jobs = Kaminari.paginate_array(selected_jobs).page(params[:page]).per(@@rpp)
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to request.referer, :notice => "Job has been successfully removed" }
    end
  end
end
