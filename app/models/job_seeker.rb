require 'validation_patterns'
require 'global_funcs'
class JobSeeker < ActiveRecord::Base
  include ValidationPatterns
  include CommonSkillFunctions
  attr_protected :email
  attr_accessible :name, :gender, :date_of_birth,
                  :password, :password_confirmation, :auth_token,
                  :location, :mobile_number, :skill_name, :experience,
                  :industry, :photo, :resume, :activated, :password_reset_token,
                  :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at,
                  :resume_file_name, :resume_content_type, :resume_file_size, :resume_updated_at

  has_many :job_applications, :dependent => :destroy
  has_many :jobs, :through => :job_applications # has-many through

  has_secure_password

  has_many :skills_associations, :as => :skillable, :dependent => :destroy
  has_many :skills, :through => :skills_associations

  has_attached_file :resume
  validates :resume_file_name, :allow_blank => true, :format => {
    :with => PATTERNS['resume'], 
    :message => "Invalid Resume Format: Allowed Formats Are Only in PDF, DOCx, Doc and Text"
  }
  
  has_attached_file :photo, :styles => { :small => "175x175>"}, 
  :default_url => '/assets/default-photo/default.gif'
  validates :photo_file_name, :allow_blank => true, :format => { 
   :with => PATTERNS['photo'],
   :message => "Invalid Photo Format: Allowed Formats Are Only in jpeg, jpg, png, ico and gif"
  }
  
  validates :name, :email, :presence  => true
  validates :gender, :inclusion => 1..3
  validates :email, :uniqueness => true, :unless => proc { |user| user.email.blank? }
  validates_format_of :email,
    :with => PATTERNS['email'],
    :unless => proc { |user| user.email.blank? }

  validates :password, :presence => true, :if => :password
  validates :password, :length => { :minimum => 6 }, 
            :unless => proc { |user| user.password.blank? }
  validates :password_confirmation, :presence => true, :unless => proc { |job_seeker| job_seeker.password.blank? } 

  validates :mobile_number, :numericality => { :only_integer => true, :message => "The mobile number should be numeric" }, :length => { :is => 10 }, :allow_blank => true

  after_create :send_confirmation_email

  def skill_name
    get_skill_set
  end

  def skill_name=(skill_arr)
    set_skill_set(skill_arr)
  end

  def self.get_gender_values
    { I18n.t("male") => 1, I18n.t("female") => 2, I18n.t("others") => 3 }
  end

  private

  def send_confirmation_email
    send_confirmation_mail_with_link
  end

  #FIXME_AB: As a good practice put all constants, validation, associations, callbacks grouped together and put them on the top of file i.e. before start defining method

  GENDER = { 'Male' => 1, 'Female' => 2, 'Others' => 3 }

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
