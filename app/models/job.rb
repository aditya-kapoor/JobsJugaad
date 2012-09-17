class Job < ActiveRecord::Base
  attr_accessible :description, :location, :skill_set, :salary, :keywords
  belongs_to :employer
  has_many :job_applications
  has_many :job_seekers, :through => :job_applications
  has_many :skills, :as => :key_skill
end
