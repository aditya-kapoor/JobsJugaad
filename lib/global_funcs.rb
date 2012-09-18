public 
def get_skill_set
  self.skills.collect(&:name).join(", ")
end

def set_skill_set(skill_arr)
  new_skillset = skill_arr.split(",").each { |word| word.strip! }
  old_skillset = self.skills.collect(&:name)
  median_skillset = new_skillset & old_skillset
  skills_to_be_deleted = old_skillset - median_skillset
  skill_to_be_added = new_skillset - median_skillset
  skills_to_be_deleted.each do |skill|
    self.skills.find_by_name(skill).delete
  end
  skill_to_be_added.each do |skill|
    self.skills.find_or_create_by_name(:name => skill)
  end
end