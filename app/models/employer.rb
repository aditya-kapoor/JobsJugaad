class Employer < ActiveRecord::Base
  attr_accessible :name, :email, :website, :description, 
                  :password, :password_confirmation, :photo,
                  :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at,
                  :auth_token, :activated, :password_reset_token

  has_many :jobs, :dependent => :destroy
  has_secure_password

  validates :name, :presence  => true

  validates :password, :presence => true, :if => :password
  validates :password, :length => { :minimum => 6 }, :unless => proc { |user| user.password.blank? }
  validates :password_confirmation, :presence => true, :if => :password 
  
  validates :email, :presence => true, :uniqueness => true
  validates_format_of :email,
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    :message => "Doesn't Looks the correct email ID", :unless => proc { |user| user.email.blank? }

  validates :website, :presence => true
  validates_format_of :website, 
    :with    => /^(https?:\/\/)?((([A-z]+)\.)*)([A-z]+\.[A-z]{2,4})$/,
    :message => "Doesn't looks like correct Website URL" 

  has_attached_file :photo, :styles => { :small => "175x175>" }, 
    :default_url => '/assets/default-photo/default.gif'

  validates_attachment_size :photo, :less_than => 6.megabytes, :message => "Must be less than 6 MB"
  validates :photo_file_name, :allow_blank => true, :format => {
    :with => %r{[.](jpg|jpeg|png|ico|gif)$}i, 
    :message => "Invalid Photo Format: Allowed Formats Are Only in jpeg, jpg, png, ico and gif"
  }

  after_create :send_authentication_email
  
  def send_authentication_email
    auth_token = BCrypt::Password.create("Tutu")
    self.update_attributes(:auth_token => auth_token, :activated => false)
    Notifier.activate_user(self, auth_token).deliver
  end
end
