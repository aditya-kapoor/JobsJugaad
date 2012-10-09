 module JobsControllerHelperFunctions 
  def return_jobs_by_salary
    temp = []
    min_sal_jobs = Job.salary_type(params[:sal_type]).salary_minimum(params[:sal_min])
    max_sal_jobs = Job.salary_type(params[:sal_type]).salary_maximum(params[:sal_max])
    temp.concat(min_sal_jobs & max_sal_jobs)
  end

  def return_jobs_by_location
    temp = []
    params[:location].split(",").each do |loc|
      temp.concat(Job.location(loc.strip))
    end
    temp
  end

  def return_jobs_by_skills
    temp = []
    params[:skills].split(",").each do |s|
      Skill.skill_name(s.strip).each do |sks|
        temp.concat(sks.jobs)
      end
    end
    temp
  end

end