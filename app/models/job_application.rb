class JobApplication < ActiveRecord::Base
  attr_accessible :interview_on, :remarks, :job_seeker_id, :job_id

  state_machine :initial => :applied do 
    event :rejected do 
      transition :applied => :rejected
    end

    event :shortlist do 
      transition :applied => :shortlisted
    end

    event :calling_for_interview do 
      transition :shortlisted => :called_for_interview
    end

    event :called_for_interview do 
      transition :called_for_interview => :given_offer
    end

    event :accepted_offer do 
      transition :given_offer => :accepted_offer
    end

    event :rejected_offer do
      transition :given_offer => :rejected_offer
    end
  end

  belongs_to :job
  belongs_to :job_seeker
  
  # validate :validate_interview_schedule, :on => :update
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
