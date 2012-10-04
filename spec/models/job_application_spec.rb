require 'spec_helper'

module JobApplicationSpecHelper
  def valid_job_application_attributes
  { :interview_on => Date.today,
    :remarks => "This column is for place and time of interview"
  }
  end
end

describe JobApplication do
  include JobApplicationSpecHelper
  before(:each) do
    @job_application = JobApplication.new
  end
  it "Interview cannot be in the past" do
    @job_application.attributes = valid_job_application_attributes.with(:interview_on => Date.parse("28/10/2011"))
    @job_application.should have(1).error_on(:interview_on)
    @job_application.errors[:interview_on].should eq(["cannot be scheduled in past"])
  end
  # it "Interview Date should have valid format" do
  #   @job_application = JobApplication.find_by_job_seeker_id_and_job_id(6, 1) 
  #   @job_application.update_attributes(:interview_on => "testing", :remarks => "hjsdhjsh")
  #   @job_application.should have(1).error_on(:interview_on)
  #   @job_application.errors[:interview_on].should eq(["must be Entered in correct format"])
  # end
  # it "Date should not be null" do 
  #   @job_application.attributes = valid_job_application_attributes.only(:interview_on => "")
  #   @job_application.should have(1).error_on(:interview_on)
  #   @job_application.errors[:interview_on].should eq(["must be Entered in correct format"])
  # end
  it "Valid Interview Date" do
    @job_application.attributes = valid_job_application_attributes.with(:interview_on => "28/12/2012")
    @job_application.should have(0).error_on(:interview_on)
  end  
end 