module JobsHelper

  def get_submit_label
    unless session[:id].nil? 
      "Apply to Job"
    else
      "Login to apply to job"
    end
  end

  def is_resume_missing?(url)
    if url.split("/").pop == "missing.png"
      true
    else
      false
    end
  end
  
end
