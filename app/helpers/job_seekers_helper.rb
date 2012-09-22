module JobSeekersHelper
  def get_skills(user)
    skill_set = ""
    user.skills.each do |skill|
      skill_set += skill.name
      skill_set += ", "
    end
    skill_set
  end
end
