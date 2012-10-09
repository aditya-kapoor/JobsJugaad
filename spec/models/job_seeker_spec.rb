require 'spec_helper'

describe JobSeeker do
  include ValidAttributeCollection
  before(:each) do
    @job_seeker = JobSeeker.new
  end

  describe "Methods" do
    before(:each) do 
      @job_seeker.attributes = valid_job_seeker_attributes
    end
    it "skill name should return the comma separed string of skills of job" do
      @job_seeker.skill_name.should eq ("php, ruby")
    end
  end

  describe "Relationships" do
    
    before(:each) do
      @employer = Employer.create(valid_employer_attributes)
      @job = @employer.jobs.create(valid_job_attributes)
      @job1 = @employer.jobs.create(valid_job_attributes.with(:title => "Testing Job 2"))
      @job_seeker = JobSeeker.create(valid_job_seeker_attributes)
      @job_seeker.jobs << @job << @job1
    end

    describe "Jobs" do 
      it "should have jobs method" do # how to add dependent destroy and through
        @job_seeker.should respond_to(:jobs)
      end
      it "should have a number of job applications" do 
        @job_seeker.should respond_to(:job_applications)
        @job_seeker.should have(0).error_on(:job_applications)
      end
      it "should apply to a number of jobs" do
        @job_seeker.should have(0).error_on(:jobs)
      end
      it "Jobs must return an array containing the jobs which the user has applied" do
        @job_seeker.jobs.should eq([@job, @job1])
      end
      it "once the job seeker is destroyed its all job applications must be removed" do
        jobs_applied = @job_seeker.job_applications
        @job_seeker.destroy
        jobs_applied.should be_empty
      end
    end
    describe "Skills" do 
      it "should have skills method" do 
        @job_seeker.should respond_to(:skills)
      end
      it "should have a number of skill associations (XYZ)" do 
        @job_seeker.should respond_to(:skillsassociation)
      end
      it "should have a number of skills" do
        @job_seeker.should have(0).error_on(:skills)
      end
      it "Skills must return a comma separated string value having the skills of job seeker" do
        @job_seeker.skills.collect(&:name).should eq(["php", "ruby"])      
        @job_seeker.should have(0).error_on(:skills)
      end
      it "Once Job Seeker is destroyed all its skills are removed from skills associations" do
        associated_skills = @job_seeker.skillsassociation
        @job_seeker.destroy
        associated_skills.should be_empty
      end
    end
  end

  describe "Validations" do
    
    it "It can be instantiated" do
      JobSeeker.new.should be_an_instance_of(JobSeeker)
    end
    it "cannot be saved successfully" do
      JobSeeker.create.should_not be_persisted
    end
    it "name should not be nil" do
      @job_seeker.attributes = valid_job_seeker_attributes.except(:name)
      @job_seeker.should have(1).error_on(:name)
      @job_seeker.errors[:name].should eq(["can't be blank"])
    end
    it "Valid Name" do
      @job_seeker.attributes = valid_job_seeker_attributes.only(:name)
      @job_seeker.should have(0).error_on(:name)
    end
    it "Invalid Email Format" do
      @job_seeker.attributes = valid_job_seeker_attributes.with(:email => "abc@cde")
      @job_seeker.should have(1).error_on(:email)
      @job_seeker.errors[:email].should eq(["Doesn't Looks the correct email ID"])
    end
    it "Email Should not be null" do
      @job_seeker.attributes = valid_job_seeker_attributes.except(:email)
      @job_seeker.should have(1).error_on(:email)
      @job_seeker.errors[:email].should eq(["can't be blank"])
    end
    it "Email must be unique" do
      @job_seeker.attributes = valid_job_seeker_attributes
      @job_seeker.save
      @job_seeker1 = JobSeeker.new()
      @job_seeker1.attributes = valid_job_seeker_attributes
      @job_seeker1.save
      @job_seeker1.should have(1).error_on(:email)
      @job_seeker1.errors[:email].should eq(["has already been taken"])
    end
    it "Valid Email" do
      @job_seeker.attributes = valid_job_seeker_attributes.only(:email)
      @job_seeker.should have(0).error_on(:email)
    end
    # it "password should not be blank" do
    #   @job_seeker.attributes = valid_job_seeker_attributes.except(:password)
    #   @job_seeker.should have(2).error_on(:password)
    #   @job_seeker.errors[:password].should eq(["doesn't match confirmation", "can't be blank"])
    # end
    it "password confirmation should not be blank" do
      @job_seeker.attributes = valid_job_seeker_attributes.except(:password_confirmation)
      @job_seeker.should have(1).error_on(:password_confirmation)
      @job_seeker.errors[:password_confirmation].should eq(["can't be blank"])
    end
    it "password should have at least six characters" do
      @job_seeker.attributes = valid_job_seeker_attributes.with(:password => "1234")
      @job_seeker.should have(2).error_on(:password)
      @job_seeker.errors[:password].should eq(["doesn't match confirmation", "is too short (minimum is 6 characters)"])
    end
    it "password should match the password confirmation" do
      @job_seeker.attributes = valid_job_seeker_attributes.with(:password => "123456", 
        :password_confirmation => "1234")
      @job_seeker.should have(1).error_on(:password)
      @job_seeker.errors[:password].should eq(["doesn't match confirmation"])
    end
    it "password and confirmation should have at least six characters" do
      @job_seeker.attributes = valid_job_seeker_attributes.with(:password => "1234", :password_confirmation => "1234")
      @job_seeker.should have(1).error_on(:password)
      @job_seeker.errors[:password].should eq(["is too short (minimum is 6 characters)"])
    end
    it "Valid Password" do
      @job_seeker.attributes = valid_job_seeker_attributes.with(:password => "123456", :password_confirmation => "123456")
      @job_seeker.should have(0).error_on(:password)
    end
    it "Mobile Number Must be digits only" do
      @job_seeker.attributes = valid_job_seeker_attributes.with(:mobile_number => "Bad0123456")
      @job_seeker.should have(1).error_on(:mobile_number)
      @job_seeker.errors[:mobile_number].should eq(["The mobile number should be numeric"])
    end
    it "Mobile Number Should have 10 digits" do
      @job_seeker.attributes = valid_job_seeker_attributes.with(:mobile_number => "96546")
      @job_seeker.should have(1).error_on(:mobile_number)
      @job_seeker.errors[:mobile_number].should eq(["is the wrong length (should be 10 characters)"])
    end
    it "Valid Mobile Number" do
      @job_seeker.attributes = valid_job_seeker_attributes.with(:mobile_number => "9654699107")
      @job_seeker.should have(0).error_on(:mobile_number)
    end
    it "Gender Should have a legal value" do
      @job_seeker.attributes = valid_job_seeker_attributes.except(:gender)
      @job_seeker.should have(1).error_on(:gender)
      @job_seeker.errors[:gender].should eq(["can't be blank"])
    end
    it "Valid Gender Value" do
      @job_seeker.attributes = valid_job_seeker_attributes.with(:gender => 1)
      @job_seeker.should have(0).error_on(:gender)
    end
    it "Must Have Valid Profile Photo" do
      @job_seeker.attributes = valid_job_seeker_attributes.with(:photo_file_name => "photo.pdf")
      @job_seeker.should have(1).error_on(:photo_file_name)
      @job_seeker.errors[:photo_file_name].should eq(["Invalid Photo Format: Allowed Formats Are Only in jpeg, jpg, png, ico and gif"])
    end
    it "The size of the Photo must be less than 6 MB" do
      @job_seeker.attributes = valid_job_seeker_attributes.with(:photo_file_size => 9999999999)
      @job_seeker.should have(1).error_on(:photo_file_size)
      @job_seeker.errors[:photo_file_size].should eq(["Must be less than 6 MB"])
    end
    it "Has Valid a Profile Photo" do
      @job_seeker.attributes = valid_job_seeker_attributes.with(:photo_file_name => "photo.jpg")
      @job_seeker.should have(0).error_on(:photo_file_name)
    end
    it "Must Have a Valid Resume Format" do
      @job_seeker.attributes = valid_job_seeker_attributes.with(:resume_file_name => "resume.jpg")
      @job_seeker.should have(1).error_on(:resume_file_name)
      @job_seeker.errors[:resume_file_name].should eq(["Invalid Resume Format: Allowed Formats Are Only in PDF, DOCx, Doc and Text"])
    end
    it "Has Valid Profile Photo" do
      @job_seeker.attributes = valid_job_seeker_attributes.with(:resume_file_name => "resume.pdf")
      @job_seeker.should have(0).error_on(:resume_file_name)
    end
  end

  describe "Callbacks" do 
    describe "After Create" do 
      it "should receive a mail and authentication token" do
        @job_seeker = JobSeeker.create(valid_job_seeker_attributes)
        @job_seeker.auth_token.should_not be_nil
      end
    end
  end
end