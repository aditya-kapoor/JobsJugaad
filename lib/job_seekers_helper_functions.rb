module JobSeekersControllerHelperFunctions

  def check_for_already_applied
    if authorized_ids(@job_seeker).include?(Integer(session[:job_to_be_added].id))
      session[:job_to_be_added] = nil
      redirect_to :profile, :notice => "You have already applied for this job"
    else
      @job_seeker.jobs << session[:job_to_be_added]
      Notifier.delay.send_email_to_employer(session[:job_to_be_added], @job_seeker)
      session[:job_to_be_added] = nil
      redirect_to :profile, :notice => "You have successfully applied for this job"
    end
  end

  def apply_to_job_after_login
    unless session[:job_to_be_added].nil?
      @job_seeker = JobSeeker.find(session[:id])
      check_for_already_applied 
    end
  end

  def check_if_employer_can_see_job_seeker_profile?
    unless employer_authorised_to_see_profile?
      flash[:error] = "You are not allowed to see this particular profile"
      redirect_to root_path
    end
  end

  def employer_authorised_to_see_profile?    
    employer = Employer.find(session[:id])
    if (get_authorized_ids(employer).include?(params["id"].to_i))
      return true
    else 
      return false
    end
  end

  def get_authorized_ids(employer)
    authorized_ids = []
    employer.jobs.each do |job|
      authorized_ids.concat(job.job_seeker_ids)
    end
    return authorized_ids
  end
end