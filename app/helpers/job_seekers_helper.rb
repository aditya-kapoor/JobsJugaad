module JobSeekersHelper

  def get_experience
    if @job_seeker.experience.match(/Fresher/i)
      "#{@job_seeker.experience}"
    else
      "#{@job_seeker.experience} years"
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
    if @job.interview_on.nil?
      "Applied"
    else
      "Interview On (#{@job.interview_on.strftime("%d-%m-%Y")})"
    end
  end
end
