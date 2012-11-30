module JobSeekersHelper

  def get_experience
    if @job_seeker.experience.match(/Fresher/i)
      "#{@job_seeker.experience}"
    else
      "#{@job_seeker.experience} years"
    end
  end

  def check_for_apitoken
    unless @job_seeker.apitoken.blank?
      "API Token = #{@job_seeker.apitoken}"
    else
      link_to 'Register for a token', get_api_token_job_seeker_path(@job_seeker)
    end
  end

  def get_industry
    if @job_seeker.industry.nil?
      "Not Mentioned"
    else
      "#{@job_seeker.industry}"
    end
  end

  def get_skills
    if @job_seeker.skills.nil?
      "Not Mentioned"
    else
      "#{@job_seeker.skill_name}"
    end
  end

  def get_status(seeker_id, job_id)
    @job = JobApplication.find_by_job_seeker_id_and_job_id(seeker_id, job_id)
    @job.state
  end
end
