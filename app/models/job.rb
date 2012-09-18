class Job < ActiveRecord::Base
  attr_accessible :description, :location, :skill_set, :salary, :key_skills
  belongs_to :employer
  has_many :job_applications
  has_many :job_seekers, :through => :job_applications
  has_many :skills, :as => :key_skill, :dependent => :destroy

  validates :description, :presence => true, :length => { :minimum => 50 }
  validates :location, :presence => true
  validates :salary, :presence => true

  def key_skills
    get_skill_set
  end

  def key_skills=(skill_arr)
    set_skill_set(skill_arr)
  end
end
