class Employer < ActiveRecord::Base
  attr_accessible :name, :email, :website, :description
  has_many :jobs
end
