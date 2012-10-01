class Admin < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password

  validates :name, :presence => true

  validates :password, :presence => true
  validates :password, :length => { :minimum => 6 }, :unless => proc { |admin| admin.password.blank? }
  
  validates :password_confirmation, :presence => true, :unless => proc { |admin| admin.password.blank? } 
  
  validates :email, :presence => true
  validates_format_of :email,
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    :message => "Doesn't Looks the correct email ID", 
    :unless => proc { |user| user.email.blank? }
    
  validates :email, :uniqueness => true, :unless => proc { |admin| admin.email.blank? }
end
