public

  def check_image_type
    unless ['image/jpeg', 'image/png', 'image/bmp', 'image/gif'].include?(self.photo_content_type)
      errors.add('attachment', "#{self.photo_file_name} is not a valid image type" )
    end
  end

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
      sk = Skill.find_or_initialize_by_name(skill)
      self.skills.delete(sk)
    end
    skill_to_be_added.each do |skill|
      sk = Skill.find_or_initialize_by_name(skill.downcase)
      self.skills << sk   
    end
  end

  def send_activation_mail
    auth_token = BCrypt::Password.create("Tutu")
    self.update_attributes(:auth_token => auth_token, :activated => false)
    Notifier.activate_user(self, auth_token).deliver
  end