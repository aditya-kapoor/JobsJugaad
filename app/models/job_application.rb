class JobApplication < ActiveRecord::Base
  attr_accessible :interview_on, :remarks, :job_seeker_id, :job_id
  belongs_to :job
  belongs_to :job_seeker
end
