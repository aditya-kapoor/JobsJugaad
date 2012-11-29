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

  # describe "Validations" do 
  #   before(:each) do 
  #     @job = Job.create(valid_job_attributes)
  #     @job_seeker = JobSeeker.new(valid_job_seeker_attributes)
  #     @job_seeker.email = "abc@gmail.com"
  #     @job_seeker.save
  #     @job_seeker.jobs << @job
  #   end
  #   it "Interview cannot be in the past" do
  #     @job_application = @job_seeker.job_applications.first
  #     @job_application.attributes = valid_job_application_attributes.with(:interview_on => Date.parse("28/10/2011"))
  #     @job_application.should have(1).error_on(:interview_on)
  #     @job_application.errors[:interview_on].should eq(["cannot be scheduled in past"])
  #   end
  #   it "Interview Date should have valid format" do
  #     @job_application = @job_seeker.job_applications.first
  #     @job_application.attributes = valid_job_application_attributes.with(:interview_on => "2222/2222/111121")
  #     @job_application.should have(1).error_on(:interview_on)
  #     @job_application.errors[:interview_on].should eq(["must be Entered correctly"])
  #   end
  #   it "Date should not be null" do 
  #     @job_application = @job_seeker.job_applications.first
  #     @job_application.attributes = valid_job_application_attributes.except(:interview_on)
  #     @job_application.should have(1).error_on(:interview_on)
  #     @job_application.errors[:interview_on].should eq(["must be Entered correctly"])
  #   end
  #   it "Valid Interview Date" do
  #     @job_application.attributes = valid_job_application_attributes.with(:interview_on => "28/12/2012")
  #     @job_application.should have(0).error_on(:interview_on)
  #   end
  # end 

  describe "State Machines" do 
    it "should have a default state" do 
      @job_application.state.should eq("applied")
    end

    it "should have two valid events" do 
      @job_application.state_events.should eq([:rejected, :shortlist])
    end

    it "should not be able to transit to any state on rejection event" do 
      @job_application.rejected
      @job_application.state.should eq("rejected")
      @job_application.state_events.should be_empty
      @job_application.should have(0).errors_on(:state)
    end

    it "should respond to the the called_for_interview event on shortlist" do 
      @job_application.shortlist
      @job_application.state.should eq("shortlisted")
      @job_application.state_events.should eq([:calling_for_interview])
      @job_application.should have(0).errors_on(:state)
    end

    it "should respond to the the calling_for_interview event on shortlist" do 
      @job_application.shortlist
      @job_application.calling_for_interview
      @job_application.state.should eq("called_for_interview")
      @job_application.state_events.should eq([:called_for_interview])
      @job_application.should have(0).errors_on(:state)
    end

    it "should respond to the the called_for_interview event on shortlist and calling_for_interview" do 
      @job_application.shortlist
      @job_application.calling_for_interview
      @job_application.called_for_interview
      @job_application.state.should eq("given_offer")
      @job_application.state_events.should eq([:accepted_offer, :rejected_offer])
      @job_application.should have(0).errors_on(:state)
    end

    it "can accept or reject the offer" do 
      @job_application.shortlist
      @job_application.calling_for_interview
      @job_application.called_for_interview
      @job_application.should respond_to(:accepted_offer) 
      @job_application.should respond_to(:rejected_offer)
      @job_application.should have(0).errors_on(:state)
    end

    it "should not respond to invalid events on initial state" do
      @job_application.called_for_interview.should be_false
      @job_application.calling_for_interview.should be_false
      @job_application.accepted_offer.should be_false
      @job_application.rejected_offer.should be_false
    end

    it "should not respond to any event on rejected" do 
      @job_application.rejected
      @job_application.called_for_interview.should be_false
      @job_application.calling_for_interview.should be_false
      @job_application.accepted_offer.should be_false
      @job_application.rejected_offer.should be_false
    end

    it "should not respond to reject event on shortlist" do 
      @job_application.shortlist
      @job_application.rejected.should be_false
      @job_application.called_for_interview.should be_false
      @job_application.accepted_offer.should be_false
      @job_application.rejected_offer
    end

    it "should not respond to invalid event on shortlist and calling_for_interview" do 
      @job_application.shortlist
      @job_application.calling_for_interview
      @job_application.accepted_offer.should be_false
      @job_application.rejected_offer.should be_false
    end
  end
end 