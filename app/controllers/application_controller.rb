class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_cache_buster

  #FIXME_AB: Don't use things if you don't understand. 
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  #FIXME_AB: Why we need to define this method here in ApplicationController?
  #FIXME_AB: What should be its name? 
  def employer_authorised_to_see_profile?
    authorized_ids = get_authorized_ids
    #FIXME_AB: What would happen if Employer not found
    @employer = Employer.find(session[:id])
    #FIXME_AB: Please rethink about the implementation. what if there are 10,00000 jobs posted by the employer?
    @employer.jobs.each do |job|
      authorized_ids.concat(job.job_seekers.collect(&:id))
    end
    if(authorized_ids.include?(Integer(params["id"])))
      return true
    else 
      return false
    end
  end

  def get_authorized_ids
    authorized_ids = []
    @employer = Employer.find(session[:id])
    @employer.jobs.each do |job|
      authorized_ids.concat(job.job_seekers.collect(&:id))
    end
    authorized_ids
  end
  # helper_method :current_user

  #FIXME_AB: Why here?
  def authorized_ids(job_seeker)
    job_seeker.jobs.collect(&:id)
  end
end
