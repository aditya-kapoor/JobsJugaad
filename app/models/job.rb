require 'global_funcs'

class Job < ActiveRecord::Base
  include CommonSkillFunctions
  attr_accessible :title, :description, :location, :salary_min, 
                  :salary_max, :salary_type, :skill_name
  
  belongs_to :employer

  has_many :job_applications, :dependent => :destroy
  has_many :job_seekers, :through => :job_applications #has-many through
  
  has_many :skills_association, :as => :skillable, :dependent => :destroy
  has_many :skills, :through => :skills_association

  validates :title, :presence => true

  validates :description, :presence => true
  validates :description, :length => { :minimum => 50, :message => "Must have more than 50 chars" }, :unless => proc { |job| job.description.blank? }
  
  validates :location, :presence => true
  
  validates_presence_of :salary_min, :message => "Important...if you have confusion, simply enter 0"
  validates_presence_of :salary_max, :message => "It is Important to enter Maximum Salary"
  validates_presence_of :salary_type, :message => "Please Enter the Salary Type in either LPA or pm"
  validates :salary_min, :numericality => true, :unless => proc { |job| job.salary_min.blank? }
  validates :salary_max, :numericality => true, :unless => proc { |job| job.salary_max.blank? }
  validates :title, :uniqueness => { :scope => [ :description, :location, :salary_min, 
                  :salary_max, :salary_type, :employer_id ], :message => "You have already entered this job" }

  scope :location, lambda { |place| where("location like ?", "#{place}%")}

  # scope :salary_range, lambda { |min=0, max=0| where("salary_min <= ? and salary_max >= ?", min.to_i, max.to_i)   }

  # scope :salary_range, lambda { |min=0, max=0| where("salary_min <= ? or salary_max >= ?", min.to_i, max.to_i)   }

  scope :salary_minimum, lambda { |min=0| where("salary_min <= ? ", min.to_i) }

  scope :salary_maximum, lambda { |max=0| where("salary_max >= ?", max.to_i) }

  scope :salary_type, lambda { |type| where("salary_type = ?", "#{type}%")}

  SALARY_TYPE = { 'pm' => "pm", "LPA" => "LPA" }

  def skill_name
    get_skill_set
  end

  def skill_name=(skill_arr)
    set_skill_set(skill_arr)
  end
end
