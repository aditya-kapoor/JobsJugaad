class Employer < ActiveRecord::Base
  attr_accessible :name, :email, :website, :description, :password, :password_confirmation, :photo
  has_many :jobs, :dependent => :destroy
  has_secure_password
  validates :name, :presence  => true
  validates :email, :presence => true, :uniqueness => true
  validates :password, :confirmation => true, :presence => true, :if => :password
  validates :password_confirmation, :presence => true, :if => :password 
  validates :password, :length => { :minimum => 6 }, :if => :password
  
  validates_format_of :email,
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    :message => "Doesn't Looks the correct email ID"

  validates :website, :presence => true
  validates_format_of :website, 
    :with    => /^(https?:\/\/)?((([A-z]+)\.)*)([A-z]+\.[A-z]{2,4})$/,
    :message => "Doesn't looks like correct Website URL" 

  has_attached_file :photo, :styles => { :small => "175x175>"}, :default_url => '/assets/default-photo/default.gif'

  validates_attachment_size :photo, :less_than => 6.megabytes
  validate :photo, :check_content_type

  def check_content_type
    check_image_type
  end
end
