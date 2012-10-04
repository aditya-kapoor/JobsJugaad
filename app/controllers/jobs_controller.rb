class JobsController < ApplicationController

  before_filter :check_unauthorised_access, :only => [:edit, :create]

  @@rpp = 10
  def create
    @employer = Employer.find(session[:id])
    @job = @employer.jobs.build(params[:job])
    respond_to do |format|
      if @job.save
        format.html { redirect_to :eprofile, :notice => "A new job has been posted successfully" }
      else
        format.html { render :template => "employers/add_job.html.erb", :notice => "Job Could not be saved" }
      end
    end
  end

  def check_unauthorised_access
    unless session[:user_type] == "employer"
      flash[:error] = "You are not authorised to do this"
      redirect_to root_url
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

  def apply_to_job
    @job_seeker = JobSeeker.find(session[:id])
    authorized_ids = authorized_ids(@job_seeker)
    if authorized_ids.include?(Integer(params[:job_id]))
      redirect_to :profile, :notice => "You have already applied for this job"
    else
      job = Job.find(params[:job_id])
      @job_seeker.jobs << job
      Notifier.send_email_to_employer(job, @job_seeker).deliver
      redirect_to :profile, :notice => "You have successfully applied to this job"
    end
  end

  def apply
    if session[:id].nil?
      session[:job_to_be_added] = Job.find_by_id(params[:job_id])
      redirect_to :root, :notice => "Please Login or Register as the job seeker"
    else
      if session[:user_type] == "employer"
        redirect_to :root, :notice => "You are Logged in as employer. Please login as the Job Seeker"
      else
        apply_to_job
      end
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
      min_sal_jobs = Job.salary_type(params[:sal_type]).salary_minimum(params[:sal_min])
      max_sal_jobs = Job.salary_type(params[:sal_type]).salary_maximum(params[:sal_max])
      jobs_by_salary.concat(min_sal_jobs & max_sal_jobs)
    end

    if jobs_by_location.empty?
      if jobs_by_skills.empty?
        if jobs_by_salary.empty?
          selected_jobs = []
        else
          selected_jobs = jobs_by_salary
        end
      else
        if jobs_by_salary.empty?
          selected_jobs = jobs_by_skills
        else
          selected_jobs = (jobs_by_skills & jobs_by_salary)
        end
      end
    else
      if jobs_by_skills.empty?
        if jobs_by_salary.empty?
          selected_jobs = jobs_by_location
        else
          selected_jobs = jobs_by_location & jobs_by_salary
        end
      else
        if jobs_by_salary.empty?
          selected_jobs = jobs_by_location & jobs_by_skills
        else
          selected_jobs = jobs_by_location & jobs_by_skills & jobs_by_salary
        end
      end
    end

  @jobs = Kaminari.paginate_array(selected_jobs).page(params[:page]).per(@@rpp)
  end

  def return_jobs_by_location
    temp = []
    params[:location].split(",").each do |loc|
      temp.concat(Job.location(loc.strip))
    end
    temp
  end

  def return_jobs_by_skills
    temp = []
    params[:skills].split(",").each do |s|
      temp.concat(Skill.skill_name(s.strip)[0].jobs)
    end
    temp
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to request.referer, :notice => "Job has been successfully removed" }
    end
  end
end
