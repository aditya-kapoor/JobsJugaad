require 'spec_helper'

describe Skill do 
  include ValidAttributeCollection
  before(:each) do
    @skill = Skill.new
  end
  describe "Relationships" do
    before(:each) do
      @job_seeker = JobSeeker.create(valid_job_seeker_attributes)
      @job_seeker.email = "testing_js1@testing.com"
      @job_seeker.save
      @job_seeker1 = JobSeeker.create(valid_job_seeker_attributes)
      @job_seeker1.email = "testing_js2@testing.com"
      @job_seeker1.save
      @job = Job.create(valid_job_attributes)
      @job1 = Job.create(valid_job_attributes.with(:title => "testing job 2"))
      @skill = Skill.create(valid_skill_attributes)
      @job_seeker.skills << @skill
      @job_seeker1.skills << @skill
      @job.skills << @skill
      @job1.skills << @skill
    end
    it "should have skills associations method" do
      @skill.should respond_to(:skills_association)
    end
    
    it "should have jobs method" do
      @skill.should respond_to(:jobs)
    end
    it "should have a number of jobs" do
      @job.skills << @skill
      @job1.skills << @skill
      @skill.should have(0).error_on(:jobs)
    end
    it "should return the jobs" do
      @skill.jobs.should eq([@job, @job1])
    end

    it "should have job seekers method" do
      @skill.should respond_to(:job_seekers)
    end
    it "should have a number of job seekers" do
      @job_seeker.skills << @skill
      @job_seeker1.skills << @skill
      @skill.should have(0).error_on(:job_seekers)
    end
    it "should return the job seekers" do
      @skill.job_seekers.should eq([@job_seeker, @job_seeker1])
    end
  end

  describe "Validations" do 
    it "name should not be empty" do
      @skill.attributes = valid_skill_attributes.except(:name)
      @skill.should have(1).error_on(:name)
      @skill.errors[:name].should eq(["Please Enter A Valid Name"])
    end
    it "should have unique skill value" do
      @skill.attributes = valid_skill_attributes
      @skill.save
      @skill1 = Skill.create(:name => "testing skill")
      @skill1.save
      @skill1.should have(1).error_on(:name)
      @skill1.errors[:name].should eq(["This Name has already been taken"])
    end
    it "Valid Skill" do
      @skill.attributes = valid_skill_attributes
      @skill.should have(0).error_on(:name)
    end
  end
end