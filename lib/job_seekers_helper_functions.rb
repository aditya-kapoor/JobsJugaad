module JobSeekersControllerHelperFunctions

  def check_for_already_applied
    if authorized_ids(@job_seeker).include?(Integer(session[:job_to_be_added].id))
      session[:job_to_be_added] = nil
      redirect_to :profile, :notice => "You have already applied for this job"
    else
      @job_seeker.jobs << session[:job_to_be_added]
      Notifier.send_email_to_employer(session[:job_to_be_added], @job_seeker).deliver
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
end