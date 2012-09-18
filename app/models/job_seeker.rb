
class JobSeeker < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :location, :mobile_number, :key_skills, :experience, :industry
  has_many :job_applications
  has_many :jobs, :through => :job_applications
  has_many :skills, :as => :key_skill
  # accepts_nested_attributes_for :skills, :allow_destroy => true

  has_secure_password
  validates :name, :presence  => true
  validates :email, :presence => true, :uniqueness => true
  validates :password, :confirmation => true, :presence => true, :if => :password
  validates :password_confirmation, :presence => true, :if => :password 
  validates :password, :length => { :minimum => 6 }, :if => :password
  
  validates_format_of :email,
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    :message => "Doesn't Looks the correct email ID"

  def key_skills
    self.get_skill_set
  end

  def key_skills=(skill_arr)
    self.set_skill_set(skill_arr)
  end

  def industry_options
    JobSeeker::INDUSTRY
  end

  INDUSTRY = {
  "Audit" => "Audit",
  "Accounting" => "Accounting",
  "Administration" => "Administration",
  "Advertising" => "Advertising",
  "Entertainment" => "Entertainment",
  "Travel" => "Travel",
  "Top Management" => "Top Management",
  "Charted Accounting" => "Charted Accounting",
  "IT" => "IT"
  }

  EXPERIENCE = {
    "Fresher" => "fresher",
    "0"  => "0",
    "1"  => "1",
    "2"  => "2",
    "3"  => "3",
    "4"  => "4",
    "5"  => "5",
    "6"  => "6",
    "7"  => "7",
    "8"  => "8",
    "9"  => "9",
    "10" => "10",
    "11" => "10+"
  }
end
