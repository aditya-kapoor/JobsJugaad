require 'spec_helper'

describe JobApplication do
  include ValidAttributeCollection
  before(:each) do
    @job_application = JobApplication.new
  end

  describe "Relationships" do
    before(:each) do
      @job_application = JobApplication.create(valid_job_application_attributes)
    end
    it "should belong to job_seeker" do
      @job_application.should respond_to(:job_seeker)
    end
    it "should belong to job" do
      @job_application.should respond_to(:job) 
    end
  end

  describe "Validations" do 
    before(:each) do 
      @job = Job.create(valid_job_attributes)
      @job_seeker = JobSeeker.new(valid_job_seeker_attributes)
      @job_seeker.email = "abc@gmail.com"
      @job_seeker.save
      @job_seeker.jobs << @job
    end
    it "Interview cannot be in the past" do
      @job_application = @job_seeker.job_applications.first
      @job_application.attributes = valid_job_application_attributes.with(:interview_on => Date.parse("28/10/2011"))
      @job_application.should have(1).error_on(:interview_on)
      @job_application.errors[:interview_on].should eq(["cannot be scheduled in past"])
    end
    it "Interview Date should have valid format" do
      @job_application = @job_seeker.job_applications.first
      @job_application.attributes = valid_job_application_attributes.with(:interview_on => "2222/2222/111121")
      @job_application.should have(1).error_on(:interview_on)
      @job_application.errors[:interview_on].should eq(["must be Entered correctly"])
    end
    it "Date should not be null" do 
      @job_application = @job_seeker.job_applications.first
      @job_application.attributes = valid_job_application_attributes.except(:interview_on)
      @job_application.should have(1).error_on(:interview_on)
      @job_application.errors[:interview_on].should eq(["must be Entered correctly"])
    end
    it "Valid Interview Date" do
      @job_application.attributes = valid_job_application_attributes.with(:interview_on => "28/12/2012")
      @job_application.should have(0).error_on(:interview_on)
    end
  end 
end 