require 'spec_helper'

describe Employer do
  include ValidAttributeCollection
  before(:each) do
    @employer = Employer.new
  end

  describe "Relationships" do 
    before(:each) do
      @employer.save(:validate => false)
      @job1 = @employer.jobs.create(valid_job_attributes)
      @job2 = @employer.jobs.create(valid_job_attributes.with(:title => "Testing Job 1"))
    end

    it "should have a number of jobs" do 
      @employer.should respond_to(:jobs)
      @employer.should have(0).error_on(:jobs)
    end

    it "Should have more than one jobs" do
      @employer.should have(0).error_on(:jobs)
    end

    it "should return an array of jobs" do
      @employer.jobs.should eq([@job1, @job2])
    end

    it "The Employer Once deleted must have all the jobs deleted " do
      jobs_of_employer = @employer.jobs
      @employer.destroy
      Job.all.should_not include(jobs_of_employer)
    end

    it "should post unique jobs on the portal" do
      @job3 = @employer.jobs.create(valid_job_attributes)
      @employer.should have(1).error_on(:jobs)
      @employer.errors[:jobs].should eq(["Doesn't have correct format"])
    end
  end

  describe "Validations" do

    it "It can be instantiated" do
      Employer.new.should be_an_instance_of(Employer)
    end
    it "cannot be saved successfully" do
      Employer.create.should_not be_persisted
    end
    it "name should not be nil" do
      @employer.attributes = valid_employer_attributes.except(:name)
      @employer.should have(1).error_on(:name)
      @employer.errors[:name].should eq(["Please Enter A Valid Name"])
    end
    it "Valid Name" do
      @employer.attributes = valid_employer_attributes.only(:name)
      @employer.should have(0).error_on(:name)
    end
    it "Invalid Email Format" do
      @employer.email = "abc@"
      @employer.should have(1).error_on(:email)
      @employer.errors[:email].should eq(["Doesn't Looks the correct email ID"])
    end
    it "Email Should not be null" do
      @employer.attributes = valid_employer_attributes.except(:email)
      @employer.should have(1).error_on(:email)
      @employer.errors[:email].should eq(["Please Enter A Valid Email"])
    end
    it "Email must be unique" do
      @employer.attributes = valid_employer_attributes
      @employer.email = "abc@cde.com"
      @employer.save
      @employer1 = Employer.new(valid_employer_attributes)
      @employer1.email = "abc@cde.com"
      @employer1.save
      @employer1.should have(1).error_on(:email)
      @employer1.errors[:email].should eq(["This Email has already been taken"])
    end
    it "Valid Email" do
      @employer.email = "abc@cde.com"
      @employer.should have(0).error_on(:email)
    end
    it "password should not be blank" do
      @employer.attributes = valid_employer_attributes.with(:password => "")
      @employer.should have(2).error_on(:password)
      @employer.errors[:password].should eq(["Does not match its confirmation", "Please Enter A Valid Password"])
    end
    it "password confirmation should not be blank" do
      @employer.attributes = valid_employer_attributes.with(:password_confirmation => "789121")
      @employer.should have(1).error_on(:password)
      @employer.errors[:password].should eq(["Does not match its confirmation"])
    end
    it "password should have at least six characters" do
      @employer.attributes = valid_employer_attributes.with(:password => "1234")
      @employer.should have(2).error_on(:password)
      @employer.errors[:password].should eq(["Does not match its confirmation", "The Password must have at least 6 chars"])
    end
    it "password should match the password confirmation" do
      @employer.attributes = valid_employer_attributes.with(:password => "123456", :password_confirmation => "1234")
      @employer.should have(1).error_on(:password)
      @employer.errors[:password].should eq(["Does not match its confirmation"])
    end
    it "password and confirmation should have at least six characters" do
      @employer.attributes = valid_employer_attributes.with(:password => "1234", :password_confirmation => "1234")
      @employer.should have(1).error_on(:password)
      @employer.errors[:password].should eq(["The Password must have at least 6 chars"])
    end
    it "Valid Password" do
      @employer.attributes = valid_employer_attributes.with(:password => "123456", :password_confirmation => "123456")
      @employer.should have(0).error_on(:password)
    end
    it "Must Have a Valid Profile Photo" do
      @employer.attributes = valid_employer_attributes.with(:photo_file_name => "photo.pdf")
      @employer.should have(1).error_on(:photo_file_name)
      @employer.errors[:photo_file_name].should eq(["Invalid Photo Format: Allowed Formats Are Only in jpeg, jpg, png, ico and gif"])
    end
    it "The size of the Photo must be less than 6 MB" do
      @employer.attributes = valid_employer_attributes.with(:photo_file_size => 9999999999)
      @employer.should have(1).error_on(:photo_file_size)
      @employer.errors[:photo_file_size].should eq(["Must be less than 6 MB"])
    end
    it "Has Valid Profile Photo" do
      @employer.attributes = valid_employer_attributes.with(:photo_file_name => "photo.jpg")
      @employer.should have(0).error_on(:photo_file_name)
    end
  end

  describe "Callbacks" do
    describe "After Create" do
      it "should receive a mail and an auth token" do
        @employer.attributes = valid_employer_attributes
        @employer.email = "abc@cde.com"
        @employer.save
        @employer.auth_token.should_not be_nil
      end
    end
  end
end