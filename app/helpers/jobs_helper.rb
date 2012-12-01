module JobsHelper

  def get_submit_label
    unless session[:id].nil? 
      "Apply to Job"
    else
      "Login to apply to job"
    end
  end
  
  def get_invalid_states(job_application)
    all_events = JobApplication.state_machine.events.map &:name
    all_events - job_application.state_events
  end

  def is_resume_missing?(url)
    if url.split("/").pop == "missing.png"
      true
    else
      false
    end
  end
  
end
