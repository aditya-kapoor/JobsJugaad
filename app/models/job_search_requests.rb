class JobSearchRequests < ActiveRecord::Base
  attr_accessible :duration, :location, :sal_max, :sal_min, :sal_type, :skills
end
