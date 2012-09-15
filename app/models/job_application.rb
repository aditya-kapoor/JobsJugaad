class JobApplication < ActiveRecord::Base
  attr_accessible :interview_on, :remarks
  belongs_to :job
  belongs_to :job_seeker
end
