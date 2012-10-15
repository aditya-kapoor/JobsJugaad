class Job < ActiveRecord::Base
  attr_accessible :title, :description, :location, :salary_min, 
                  :salary_max, :salary_type, :skill_name
  
  belongs_to :employer

  has_many :job_applications, :dependent => :destroy
  has_many :job_seekers, :through => :job_applications #has-many through
  
  # has_many :skills, :as => :key_skill, :dependent => :destroy
  
  # has_many :xyz, :as => :skillable, :dependent => :destroy
  # has_many :skills, :through => :xyz

  #FIXME_AB: skillsassociation or skills_associations
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
  validates :title, :uniqueness => { :scope => [ :description, :location, :salary_min, 
                  :salary_max, :salary_type, :employer_id ], :message => "You have already entered this job" }

  #FIXME_AB: is this working fine. Dont we need % signs
  scope :location, lambda { |place| where("location like ?", "#{place}")}
  #FIXME_AB: I don't see any need of this scope. Same can be achieved by other two scopes Job.salary_minimum.salary_maximum
  scope :salary_range, lambda { |min=0, max=0| where("salary_min <= ? or salary_max >= ?", min.to_i, max.to_i)   }

  scope :salary_minimum, lambda { |min=0| where("salary_min >= ? ", min.to_i) }

  scope :salary_maximum, lambda { |max=0| where("salary_max <= ?", max.to_i) }

  scope :salary_type, lambda { |type| where("salary_type = ?", type)}

  #FIXME_AB: I really don't understand use of the following hash
  SALARY_TYPE = { 'pm' => "pm", "LPA" => "LPA" }

  #FIXME_AB: if getter and setter are defined in a module then why can't we move following two methods to the same module.
  def skill_name
    get_skill_set
  end

  def skill_name=(skill_arr)
    set_skill_set(skill_arr)
  end

end
