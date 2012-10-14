 module JobsControllerHelperFunctions 
  def return_jobs_by_salary
    temp = []
    min_sal_jobs = Job.salary_type(params[:sal_type]).salary_minimum(params[:sal_min])
    max_sal_jobs = Job.salary_type(params[:sal_type]).salary_maximum(params[:sal_max])
    temp.concat(min_sal_jobs & max_sal_jobs)
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
      Skill.skill_name(s.strip).each do |sks|
        temp.concat(sks.jobs)
      end
    end
    temp
  end

  def return_consolidated_results(temp_jobs)
    temp_jobs.reject! { |x| x.empty? }
    temp_jobs.inject { |a,b| a & b } if temp_jobs.any?
  end

  def apply_to_job
    @job_seeker = JobSeeker.find(session[:id])
    authorized_ids = authorized_ids(@job_seeker)
    if authorized_ids.include?(params[:job_id].to_i)
      flash[:notice] = "You have already applied for this job"
    else
      job = Job.find(params[:job_id])
      @job_seeker.jobs << job
      Notifier.send_email_to_employer(job, @job_seeker).deliver
      flash[:notice] = "You have successfully applied to this job"
    end
    redirect_to :profile
  end

end