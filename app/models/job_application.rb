class JobApplication < ActiveRecord::Base
  attr_accessible :interview_on, :remarks, :job_seeker_id, :job_id
  belongs_to :job
  belongs_to :job_seeker
  
  validates_date :interview_on, :message => "Interview Date is in incorrect format"
  validate :interview_on_cannot_be_in_past, :if => :interview_on

  def interview_on_cannot_be_in_past
    if interview_on < Date.today
      errors.add(:interview_on, "Interview cannot be scheduled in past")
    end
  end
end
