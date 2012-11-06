require 'twitter'
require 'validation_patterns'

class Employer < ActiveRecord::Base
  include TwitterClone
  include ValidationPatterns

  attr_accessible :name, :website, :description, 
                  :password, :password_confirmation, :photo,
                  :photo_file_name, :photo_content_type, :photo_file_size, 
                  :photo_updated_at, :auth_token, :activated, :password_reset_token

  attr_protected :email

  has_many :jobs, :dependent => :destroy
  has_secure_password

  validates :name, :email, :website, :presence  => true

  validates :password, :presence => true, :if => :password
  validates :password, :length => { :minimum => 6 }, :unless => proc { |user| user.password.blank? }
  validates :password_confirmation, :presence => true, :unless => proc { |user| user.password.blank? } 
  
  validates :email, :uniqueness => true
  
  validates_format_of :email,
    :with => PATTERNS['email'],
    :message => "Doesn't Looks the correct email ID", :unless => proc { |user| user.email.blank? }

  validates_format_of :website, 
    :with    => PATTERNS['website'],
    :message => "Doesn't looks like correct Website URL" 

  has_attached_file :photo, :styles => { :small => "175x175>" }, 
    :default_url => '/assets/default-photo/default.gif'

  validates_attachment_size :photo, :less_than => 6.megabytes, :message => "Must be less than 6 MB"
  
  # validates_format_of :photo_content_type, :with => /^image/, 
  #   :message => "Invalid Photo Format: Allowed Formats Are Only in jpeg, jpg, png, ico and gif"

  validates :photo_file_name, :allow_blank => true, :format => { :with => PATTERNS['photo'],
   :message => "Invalid Photo Format: Allowed Formats Are Only in jpeg, jpg, png, ico and gif"
  }
 
  after_create :send_confirmation_email
  
  def send_confirmation_email
    send_confirmation_mail_with_link
  end
end
