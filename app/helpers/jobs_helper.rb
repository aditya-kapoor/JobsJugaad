module JobsHelper

  def get_submit_label
    unless session[:id].nil? 
      "Apply to Job"
    else
      "Login to apply to job"
    end
  end
end
