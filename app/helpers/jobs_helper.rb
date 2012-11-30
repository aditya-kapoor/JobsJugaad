module JobsHelper

  def get_submit_label
    unless session[:id].nil? 
      "Apply to Job"
    else
      "Login to apply to job"
    end
  end

  def get_application(seeker_id)
    @job_application = JobApplication.find_by_job_id_and_job_seeker_id(params[:id], seeker_id)
  end

  def get_invalid_states(seeker_id)
    @job_application = JobApplication.find_by_job_id_and_job_seeker_id(params[:id], seeker_id)
    @job_application.state_paths.events - @job_application.state_events
  end

  def is_resume_missing?(url)
    if url.split("/").pop == "missing.png"
      true
    else
      false
    end
  end
  
end
