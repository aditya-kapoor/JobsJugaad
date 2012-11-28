require 'jobs_controller_helper_functions'
class JobsController < ApplicationController
    include JobsControllerHelperFunctions

  before_filter :check_for_valid_access, :only => [:view_applicants]
  before_filter :check_unauthorised_access, :only => [:edit, :create, :view_applicants]
  before_filter :check_for_session, :only => [:apply]
  before_filter :is_job_found, :only => [:edit, :view_applicants, :show]

  @@rpp = 2

  def check_unauthorised_access
    unless session[:user_type] == "employer"
      flash[:error] = "You are not authorised to do this"
      redirect_to root_url
    end
  end

  def check_for_valid_access
    employer = Employer.find_by_id(session[:id])
    if employer && session[:user_type] == "employer"
      does_job_belongs_to_employer?(employer)
    else
      flash[:error] = "You are not logged in as employer"
      redirect_to root_url
    end
  end

  def does_job_belongs_to_employer?(employer)
    unless employer.job_ids.include?(params[:id].to_i)
      flash[:error] = "You Don't Own This Job"
      redirect_to root_url
    end
  end

  def check_for_session
    if session[:id].nil?
      session[:job_to_be_added] = Job.find_by_id(params[:job_id])
      redirect_to :root, :notice => "Please Login or Register as the job seeker"
    end
  end

  def is_job_found
    job = Job.find_by_id(params[:id])
    unless job
      flash[:error] = "No Job Found"
      redirect_to root_url
    end
  end

  def create
    @employer = Employer.find(session[:id])
    @job = @employer.jobs.build(params[:job])
    respond_to do |format|
      if @job.save
        format.html { redirect_to :eprofile, :notice => "A new job has been posted successfully" }
        format.json { render :text=> "A new job has been posted successfully" }
      else
        format.html { render :template => "employers/add_job", :notice => "Job Could not be saved" }
        format.json { render :text => "There Was Some Error with your job" }
      end
    end
  end

  def index
    respond_to do |format|
      if params[:token].present?
        @jobs = Employer.find_by_apitoken(params[:token]).jobs
        format.html { flash[:error] = "Only JSON Format Allowed"; redirect_to root_url }
        format.json { render :json => @jobs }
      else
        format.html { flash[:error] = "No token present"; redirect_to root_url }
        format.json { flash[:error] = "No token present"; redirect_to root_url }
      end
    end
  end

  def edit
    @job = Job.find_by_id(params[:id])
  end

  def view_applicants
    @job = Job.includes(:job_seekers => :skills).find_by_id(params[:id])
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
    ActiveSupport::Notifications.instrument("jobs.search", 
      :search => {
        :location => params[:location], 
        :skills => params[:skills], 
        :salary_min => params[:sal_min], 
        :salary_max => params[:sal_max],
        :salary_type => params[:sal_type]
        }) do
    end
      # jobs_by_location = []
      # jobs_by_skills = []
      # jobs_by_salary = []
      # selected_jobs = []

      # jobs_by_location = return_jobs_by_location unless params[:location].empty? 
      # jobs_by_skills = return_jobs_by_skills unless params[:skills].empty?
      # jobs_by_salary = return_jobs_by_salary unless params[:sal_min].empty? && params[:sal_max].empty?
      
      # selected_jobs = return_consolidated_results([jobs_by_location, jobs_by_skills, jobs_by_salary]) || []
      # @jobs = Kaminari.paginate_array(selected_jobs).page(params[:page]).per(@@rpp)

      selected_jobs = params[:location].blank? ? Job.search : Job.location("#{params[:location].gsub(', ', '|')}")
      selected_jobs = params[:skills].blank? ? selected_jobs : selected_jobs.skills("#{params[:skills].gsub(', ','|')}")
      selected_jobs = params[:sal_min].to_i == 0 ? selected_jobs : selected_jobs.sal_min(params[:sal_min].to_i)
      selected_jobs = params[:sal_max].to_i == 0 ? selected_jobs : selected_jobs.sal_max(params[:sal_max].to_i)

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
