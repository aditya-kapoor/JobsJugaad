class Job < ActiveRecord::Base
  attr_accessible :title, :description, :location, :salary_min, 
                  :salary_max, :salary_type, :skill_name
  belongs_to :employer
  has_many :job_applications
  has_many :job_seekers, :through => :job_applications #has-many through
  
  # has_many :skills, :as => :key_skill, :dependent => :destroy
  
  # has_many :xyz, :as => :skillable, :dependent => :destroy
  # has_many :skills, :through => :xyz

  has_many :skillsassociation, :as => :skillable, :dependent => :destroy
  has_many :skills, :through => :skillsassociation



  validates :title, :presence => true

  validates :description, :presence => true
  validates :description, :length => { :minimum => 50, :message => "Must have more than 50 chars" }, :unless => proc { |job| job.description.blank? }
  
  validates :location, :presence => true
  
  validates_presence_of :salary_min, :message => "Important...if you have confusion, simply enter 0"
  validates_presence_of :salary_max, :message => "It is Important to enter Maximum Salary"
  validates_presence_of :salary_type, :message => "Please Enter the Salary Type in either LPA or pm"
  validates :salary_min, :numericality => true, :unless => proc { |job| job.salary_min.blank? }
  validates :salary_max, :numericality => true, :unless => proc { |job| job.salary_max.blank? }

  scope :location, lambda { |place| where("location like ?", "#{place}")}
    
  def skill_name
    get_skill_set
  end

  def skill_name=(skill_arr)
    set_skill_set(skill_arr)
  end
end
