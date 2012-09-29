class JobSeeker < ActiveRecord::Base
  attr_accessible :name, :email, :gender, :date_of_birth, 
                  :password, :password_confirmation, :auth_token,
                  :location, :mobile_number, :skill_name, :experience,
                  :industry, :photo, :resume, :activated, :password_reset_token,
                  :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at,
                  :resume_file_name, :resume_content_type, :resume_file_size, :resume_updated_at


  attr_accessor :skill_name

  has_many :job_applications
  has_many :jobs, :through => :job_applications # has-many through
  
  has_many :xyz, :as => :skillable, :dependent => :destroy
  has_many :skills, :through => :xyz

  has_attached_file :resume
  validates :resume_file_name, :allow_blank => true, :format => {
    :with => %r{[.](pdf|docx|doc|txt)$}i, 
    :message => "Invalid Resume Format: Allowed Formats Are Only in PDF, DOCx, Doc and Text"
  }
  
  has_attached_file :photo, :styles => { :small => "175x175>"}, 
  :default_url => '/assets/default-photo/default.gif'

  validates_attachment_size :photo, :less_than => 6.megabytes
  validates :photo_file_name, :allow_blank => true, :format => {
    :with => %r{[.](jpg|jpeg|png|ico|gif)$}i, 
    :message => "Invalid Photo Format: Allowed Formats Are Only in jpeg, jpg, png, ico and gif"
  }
  
  has_secure_password
  validates :name, :email, :password, :presence  => true

  validates :email, :uniqueness => true, :unless => proc { |user| user.email.blank? }
  validates_format_of :email,
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    :message => "Doesn't Looks the correct email ID", 
    :unless => proc { |user| user.email.blank? }
  
  validates :password, :length => { :minimum => 6 }, 
            :unless => proc { |user| user.password.blank? }
  
  validates :password_confirmation, :presence => true, :if => :password

  validates :mobile_number,
            :numericality => { :only_integer => true, :message => "The mobile number should be numeric" }, 
            :length => { :is => 10 }, 
            :allow_blank => true

  validates :gender, :presence => true

  after_create :send_authentication_email

  def skill_name
    self.get_skill_set
  end

  def skill_name=(skill_arr)
    self.set_skill_set(skill_arr)
  end

  def send_authentication_email
    auth_token = BCrypt::Password.create("Tutu")
    self.update_attributes(:auth_token => auth_token, :activated => false)
    Notifier.activate_user(self, auth_token).deliver
    # self.send_activation_mail
  end

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
