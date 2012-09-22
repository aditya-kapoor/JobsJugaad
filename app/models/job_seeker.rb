
class JobSeeker < ActiveRecord::Base
  attr_accessible :name, :email, :gender, :date_of_birth, 
                  :password, :password_confirmation, :auth_token,
                  :location, :mobile_number, :key_skills, :experience, 
                  :industry, :photo, :resume, :activated, :password_reset_token

  has_many :job_applications
  has_many :jobs, :through => :job_applications
  has_many :skills, :as => :key_skill, :dependent => :destroy
  # accepts_nested_attributes_for :skills, :allow_destroy => true

  has_attached_file :resume
  validates :resume_file_name, :allow_blank => true, :format => {
    :with => %r{[.](pdf|docx|doc|txt)$}i, 
    :message => "Invalid Resume Format: Allowed Formats Are Only in PDF, DOCx, Doc and Text"
  }
  
  has_attached_file :photo, :styles => { :small => "175x175>"}, 
  :default_url => '/assets/default-photo/default.gif'

  validates_attachment_size :photo, :less_than => 6.megabytes
  validates_format_of :photo, :with => %r{\.(jpg|jpeg|png|ico|gif)}i, 
  :message => "Invalid Image: Allowed Formats Are Only in jpeg, jpg, png, ico and gif"
  
  
  has_secure_password
  validates :name, :presence  => true
  validates :email, :presence => true, :uniqueness => true
  validates :password, :confirmation => true, :presence => true, :if => :password
  validates :password_confirmation, :presence => true, :if => :password 
  validates :password, :length => { :minimum => 6 }, :if => :password
  
  validates_format_of :email,
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    :message => "Doesn't Looks the correct email ID"


  validates :mobile_number, 
            :numericality => { :only_integer => true }, 
            :length => { :is => 10 }, 
            :allow_blank => true

  validates :gender, :presence => true

  def key_skills
    self.get_skill_set
    # self.skills.collect(&:name).join(", ")
  end

  def key_skills=(skill_arr)
    self.set_skill_set(skill_arr)
    # skill_arr.split(",").each do |skill|
    #   self.skills.build(:name => skill)
    # end
    # # new_skillset = skill_arr.split(",").each { |word| word.strip! }
    # # old_skillset = self.skills.collect(&:name)
    # # median_skillset = new_skillset & old_skillset
    # # skills_to_be_deleted = old_skillset - median_skillset
    # # skill_to_be_added = new_skillset - median_skillset
    # # skills_to_be_deleted.each do |skill|
    # #   self.skills.find_by_name(skill).delete
    # # end
    # # skill_to_be_added.each do |skill|
    # #   self.skills.find_or_initialize_by_name(:name => skill)
    # # end
  end

  def industry_options
    JobSeeker::INDUSTRY
  end

  INDUSTRY = {
    "IT" => "IT",
    "Audit" => "Audit",
    "Accounting" => "Accounting",
    "Administration" => "Administration",
    "Advertising" => "Advertising",
    "Entertainment" => "Entertainment",
    "Travel" => "Travel",
    "Top Management" => "Top Management",
    "Charted Accounting" => "Charted Accounting",
    "Others" => "Others"
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
    "10+" => "10+"
  }
end
