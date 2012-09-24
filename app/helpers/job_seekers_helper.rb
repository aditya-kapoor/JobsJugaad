module JobSeekersHelper
  def get_skills(user)
    skill_set = ""
    user.skills.each do |skill|
      skill_set += skill.name
      skill_set += ", "
    end
    skill_set
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
