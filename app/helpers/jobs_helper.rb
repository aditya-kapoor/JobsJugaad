module JobsHelper

  def get_submit_label
    unless session[:id].nil? 
      "Apply to Job"
    else
      "Login to apply to job"
    end
  end

  def get_application(seeker_id, job_id)
    @job_application = JobApplication.find_by_job_id_and_job_seeker_id(job_id, seeker_id)
    # str = ""
    # @job_application.state_events.each do |event|
    #   event_path = "#{event}_path"
    #   str += link_to "#{event}", "#{event_path(:seeker_id=>seeker_id,:job_id=>job_id)}"
    #   str += "  "
    # end
    # str

  end

  def is_resume_missing?(url)
    if url.split("/").pop == "missing.png"
      true
    else
      false
    end
  end
  
end
