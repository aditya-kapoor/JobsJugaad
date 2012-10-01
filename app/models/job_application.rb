class JobApplication < ActiveRecord::Base
  attr_accessible :interview_on, :remarks, :job_seeker_id, :job_id
  belongs_to :job
  belongs_to :job_seeker
  
  validate :interview_on_cannot_be_in_past, :if => :interview_on
  validate :correct_interview_on_format#, :if => :interview_on
  # validate , :if => :interview_on
  
  def interview_on_cannot_be_in_past
    if interview_on < Date.today
      errors.add(:interview_on, "cannot be scheduled in past")
    end
  end

  def correct_interview_on_format
    if interview_on.nil?
      errors.add(:interview_on, "must be Entered in correct format")
    end
  end
end
