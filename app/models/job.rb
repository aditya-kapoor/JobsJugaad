class Job < ActiveRecord::Base
  attr_accessible :title, :description, :location, :skill_set, :salary_min, 
                  :salary_max, :salary_type, :key_skills
  belongs_to :employer
  has_many :job_applications
  has_many :job_seekers, :through => :job_applications
  has_many :skills, :as => :key_skill, :dependent => :destroy

  validates :description, :presence => true, :length => { :minimum => 50 }
  validates :location, :presence => true
    # validate do |job|
    #   job.errors.add_to_base("Important...if you have confusion, simply enter 0") if job.salary_min.blank?
    # end
  validates_presence_of :salary_min, :message => "Important...if you have confusion, simply enter 0"
  validates_presence_of :salary_max, :message => "It is Important to enter Maximum Salary"
  validates_presence_of :salary_type, :message => "Please Enter the Salary Type in either LPA or pm"
  validates :salary_min, :numericality => true
  validates :salary_max, :numericality => true

  scope :location, lambda { |place| where("location = ?", place)}
  scope :skill, lambda { |skill| where("name")}
  
  def key_skills
    get_skill_set
  end

  def key_skills=(skill_arr)
    set_skill_set(skill_arr)
  end
end
