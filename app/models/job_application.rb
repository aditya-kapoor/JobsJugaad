class JobApplication < ActiveRecord::Base
  attr_accessible :interview_on, :remarks, :job_seeker_id, :job_id
  
  belongs_to :job
  belongs_to :job_seeker
  
  #FIXME_AB: validate interview_schedule
  #FIXME_AB: Following two validation can be merged into one
  validate :interview_on_cannot_be_in_past, :if => :interview_on
  validate :correct_interview_on_format, :on => :update

  def interview_on_cannot_be_in_past
    if interview_on < Date.today
      errors.add(:interview_on, "cannot be scheduled in past")
    end
  end

  def correct_interview_on_format
    #FIXME_AB: Try to use Chronic gem. Chronic.parse("sep 30")
    #FIXME_AB: I don't want to see variable.nil? again. 
    if interview_on.nil?
      errors.add(:interview_on, "must be Entered in correct format")
    end
  end
end
