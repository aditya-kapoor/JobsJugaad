class JobApplication < ActiveRecord::Base
  attr_accessible :interview_on, :remarks, :job_seeker_id, :job_id
  
  belongs_to :job
  belongs_to :job_seeker
  
  validate :validate_interview_schedule, :on => :update
  # validate :validate_interview_schedule, :unless => proc { |application| application.interview_on.blank? }

  def validate_interview_schedule
    unless interview_on
      errors.add(:interview_on, "must be Entered correctly")
    else
      check_for_past_date
    end
  end

  def check_for_past_date
    if interview_on < Date.today
      errors.add(:interview_on, "cannot be scheduled in past")
    end
  end

end
