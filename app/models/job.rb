class Job < ActiveRecord::Base
  attr_accessible :description, :location, :skill_set, :salary, :key_skills
  belongs_to :employer
  has_many :job_applications
  has_many :job_seekers, :through => :job_applications
  has_many :skills, :as => :key_skill, :dependent => :destroy

  validates :description, :presence => true, :length => { :minimum => 50 }
  validates :location, :presence => true
  validates :salary, :presence => true

  scope :location, lambda { |place| where("location = ?", place)}
  scope :salary, lambda { |lower_bound, upper_bound| where("salary between ? and ?", lower_bound, upper_bound) }
  scope :salary_upto, lambda { |upper_bound, lower_bound = 0| where("salary between ? and ?", lower_bound, upper_bound) }
  scope :skill, lambda { |skill| where("name")}
  
  def key_skills
    get_skill_set
  end

  def key_skills=(skill_arr)
    set_skill_set(skill_arr)
  end
end
