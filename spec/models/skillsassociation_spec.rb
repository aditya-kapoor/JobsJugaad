require 'spec_helper'

describe Skillsassociation do
  include ValidAttributeCollection
  before(:each) do
    @skillsAssociation = Skillsassociation.new
  end

  describe "Relationships" do 
    before(:each) do
      @job = Job.create(valid_job_attributes)
      @job_seeker = JobSeeker.create(valid_job_seeker_attributes)
      @job_seeker.jobs << @job
    end
    it "should have a skillable method" do
      @skillsAssociation.should respond_to(:skillable)
      @skillsAssociation.should have(0).error_on(:skillable)
    end
    it "should have a job method" do
      @skillsAssociation.should respond_to(:skill)
      @skillsAssociation.should have(0).error_on(:skill)
    end
  end
end