require 'spec_helper'

describe Job do
  include ValidAttributeCollection
  before(:each) do
    @job = Job.new
  end

  describe "Relationships" do 
    before(:each) do 
      @employer = Employer.create(valid_employer_attributes)
      @job = @employer.jobs.create(valid_job_attributes)
      @job_seeker = JobSeeker.create(valid_job_seeker_attributes)
      @job_seeker1 = JobSeeker.create(valid_job_seeker_attributes.with(:email => "tutu@vinsole.com"))
      @job_seeker.jobs << @job
      @job_seeker1.jobs << @job
    end
    describe "belongs_to :employer" do
      it "Must Belong to Employer" do
        @job.should respond_to(:employer)
      end
    end

    describe "Job Seeker" do
      it "Must Have Job Applications method" do 
        @job.should respond_to(:job_applications)
      end
      it "Must have job seekers method" do
        @job.should respond_to(:job_seekers)
      end
      it "should have a number of job seekers" do
        @job.should have(0).error_on(:job_seekers)
      end
      it "must have a number of job applications" do
        @job.job_seekers.should eq([@job_seeker, @job_seeker1])
      end
      it "once the job is deleted all the job applications must be deleted" do
        job_applications = @job.job_applications
        @job.destroy
        job_applications.should be_empty
      end
    end

    describe "Skills" do 
      it "should have skills method" do 
        @job.should respond_to(:skills)
      end
      it "should have a number of skill associations (XYZ)" do 
        @job.should respond_to(:skillsassociation)
      end
      it "should have a number of skills" do
        @job.should have(0).error_on(:skills)
      end
      it "Skills must return a comma separated string value having the skills of job seeker" do
        @job.skills.collect(&:name).should eq(["php", "java"])      
        @job.should have(0).error_on(:skills)
      end
      it "Once Job Seeker is destroyed all its skills are removed from skills associations" do
        associated_skills = @job.skillsassociation
        @job.destroy
        associated_skills.should be_empty
      end
    end
  end

  describe "Validations" do
    it "Must Have A title" do
      @job.attributes = valid_job_attributes.except(:title)
      @job.should have(1).error_on(:title)
      @job.errors[:title].should eq(["can't be blank"])
    end
    it "Valid Title" do
      @job.attributes = valid_job_attributes.with(:title => "Testing Post")
      @job.should have(0).error_on(:title)
    end
    it "duplicate job should not be posted" do
      @employer= Employer.create(valid_employer_attributes)
      @job1 = @employer.jobs.create(valid_job_attributes)
      @job2 = @employer.jobs.create(valid_job_attributes)
      @job2.should have(1).error_on(:title)
      @job2.errors[:title].should eq(["You have already entered this job"])
    end
    it "Must Have A description" do
      @job.attributes = valid_job_attributes.with(:description => "")
      @job.should have(1).error_on(:description)
      @job.errors[:description].should eq(["can't be blank"])
    end
    it "Description must have at least 50 chars as length" do
      @job.attributes = valid_job_attributes.with(:description => "Testing description")
      @job.should have(1).error_on(:description)
      @job.errors[:description].should eq(["Must have more than 50 chars"])
    end
    it "has a valid description" do
      @job.attributes = valid_job_attributes.with(:description => "Testing description for RSpec and I am testing the count of the description of job")
      @job.should have(0).error_on(:description)
    end
    it "Must Have A location" do
      @job.attributes = valid_job_attributes.except(:location)
      @job.should have(1).error_on(:location)
      @job.errors[:location].should eq(["can't be blank"])
    end
    it "Valid Title" do
      @job.attributes = valid_job_attributes.with(:location => "Testing Location")
      @job.should have(0).error_on(:location)
    end
    it "Must Have non nil minimum salary" do
      @job.attributes = valid_job_attributes.except(:salary_min)
      @job.should have(1).error_on(:salary_min)
      @job.errors[:salary_min].should eq(["Important...if you have confusion, simply enter 0"])
    end
    it "Must Have non nil maximum salary" do
      @job.attributes = valid_job_attributes.except(:salary_max)
      @job.should have(1).error_on(:salary_max)
      @job.errors[:salary_max].should eq(["It is Important to enter Maximum Salary"])
    end
    it "Must Have numeric minimum salary" do
      @job.attributes = valid_job_attributes.with(:salary_min => "dsdds")
      @job.should have(1).error_on(:salary_min)
      @job.errors[:salary_min].should eq(["is not a number"])
    end
    it "Must Have numeric maximum salary" do
      @job.attributes = valid_job_attributes.with(:salary_max => "dsdds")
      @job.should have(1).error_on(:salary_max)
      @job.errors[:salary_max].should eq(["is not a number"])
    end
    it "Must Have salary type" do
      @job.attributes = valid_job_attributes.except(:salary_type)
      @job.should have(1).error_on(:salary_type)
      @job.errors[:salary_type].should eq(["Please Enter the Salary Type in either LPA or pm"])
    end
    it "Valid minimum salary" do
      @job.attributes = valid_job_attributes.with(:salary_min => 10000)
      @job.should have(0).error_on(:salary_min)
    end
    it "Valid maximum salary" do
      @job.attributes = valid_job_attributes.with(:salary_max => 15000)
      @job.should have(0).error_on(:salary_max)
    end
    it "Valid salary" do
      @job.attributes = valid_job_attributes.with(:salary_min => 15000, :salary_max => 25000, :salary_type => "pm")
      @job.should have(0).error_on(:salary_max)
      @job.should have(0).error_on(:salary_min)
      @job.should have(0).error_on(:salary_type)
    end
  end
end