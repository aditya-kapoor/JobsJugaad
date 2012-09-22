class JobsController < ApplicationController

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

  def edit
    begin
      @job = Job.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to :root, :notice => "Not Authorised to view this page"
    end
  end

  def view_applicants
    @job = Job.find(params[:id])
  end

  def show
    begin
      @job = Job.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to :root, :notice => "Not Authorised to view this page"
    end
  end

  def authorized_ids(job_seeker)
    job_seeker.jobs.collect(&:id)
  end

  def apply
    if session[:id].nil?
      redirect_to :root, :notice => "Please Login or Register as the job seeker"
    else
      if session[:user_type] == "employer"
        redirect_to :root, :notice => "You are Logged in as employer. Please login as the Job Seeker"
      else
        @job_seeker = JobSeeker.find(session[:id])
        authorized_ids = authorized_ids(@job_seeker)
        if authorized_ids.include?(Integer(params[:job_id]))
          redirect_to :profile, :notice => "You have already applied for this job"
        else
          @job_seeker.jobs << Job.find(params[:job_id])
          redirect_to :profile, :notice => "You have successfully applied to this job"
        end
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
    case params[:search_type]
    when "location"
      @jobs = Job.includes(:skills).location(params[:location]).page(params[:page]).per(10)
    when "skills"
      job_arr = []
      skill_set = Skill.skill_name(params[:skills]).skill_type("Job")
      skill_set.each do |job|
        job_arr << job.key_skill
      end
      @jobs = Kaminari.paginate_array(job_arr).page(params[:page]).per(10)
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to request.referer, :notice => "Job has been successfully removed" }
    end
  end
end
