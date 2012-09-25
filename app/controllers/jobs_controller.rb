class JobsController < ApplicationController

  @@rpp = 5
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
    case params[:search_type]
    when "location"
      # @jobs = Job.includes(:skills).location(params[:location]).page(params[:page]).per(@@rpp)
      job_arr = []
      (params[:location]).split(",").each do |loc|
        job_arr.concat(Job.location(loc.strip))
      end
      @jobs = Kaminari.paginate_array(job_arr).page(params[:page]).per(@@rpp)
    when "skills"
      job_arr = []
      (params[:skills]).split(",").each do |skill|
        skill_set = Skill.skill_name(skill.strip).skill_type("Job")
        skill_set.each do |job|
          job_arr << job.key_skill
        end
      end
      @jobs = Kaminari.paginate_array(job_arr).page(params[:page]).per(@@rpp)
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
