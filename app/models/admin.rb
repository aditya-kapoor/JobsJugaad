class Admin < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  validates :password, :confirmation => true, :presence => true, :if => :password
  validates :password_confirmation, :presence => true, :if => :password 
  validates :password, :length => { :minimum => 6 }, :if => :password
  validates :email, :presence => true, :uniqueness => true
end
