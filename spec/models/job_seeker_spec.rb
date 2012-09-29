require 'spec_helper'

module JobSeekerSpecHelper
  def valid_user_attributes
  { :name => "Testing Job Seeker", 
    :email => "testing@testing.com",
    :gender => "Male", 
    :date_of_birth => "01/01/1990", 
    :password => "123456",
    :password_confirmation => "123456", 
    :mobile_number => "1234567890",
    :location => "Mumbai",
    :experience => 5,
    :industry => "IT",
    :activated => false,
    :photo_file_name => "photo.jpeg",
    :photo_content_type => "image/jpeg",
    :photo_file_size => 17185,
    :photo_updated_at => Time.now,
    :resume_file_name => "resume.pdf",
    :resume_content_type => "application/pdf",
    :resume_file_size => 17185,
    :resume_updated_at => Time.now
  }
  end
end

describe JobSeeker do
  include JobSeekerSpecHelper
  before(:each) do
    @job_seeker = JobSeeker.new
  end

  it "It can be instantiated" do
    JobSeeker.new.should be_an_instance_of(JobSeeker)
  end
  it "cannot be saved successfully" do
    JobSeeker.create.should_not be_persisted
  end
  it "name should not be nil" do
    @job_seeker.attributes = valid_user_attributes.except(:name)
    @job_seeker.should have(1).error_on(:name)
    @job_seeker.errors[:name].should eq(["can't be blank"])
  end
  it "Valid Name" do
    @job_seeker.attributes = valid_user_attributes.only(:name)
    @job_seeker.should have(0).error_on(:name)
  end
  it "Invalid Email Format" do
    @job_seeker.attributes = valid_user_attributes.with(:email => "abc@cde")
    @job_seeker.should have(1).error_on(:email)
    @job_seeker.errors[:email].should eq(["Doesn't Looks the correct email ID"])
  end
  it "Email Should not be null" do
    @job_seeker.attributes = valid_user_attributes.except(:email)
    @job_seeker.should have(1).error_on(:email)
    @job_seeker.errors[:email].should eq(["can't be blank"])
  end
  it "Valid Email" do
    @job_seeker.attributes = valid_user_attributes.only(:email)
    @job_seeker.should have(0).error_on(:email)
  end
  it "password should not be blank" do
    @job_seeker.attributes = valid_user_attributes.except(:password)
    @job_seeker.should have(2).error_on(:password)
    @job_seeker.errors[:password].should eq(["doesn't match confirmation", "can't be blank"])
  end
  it "password confirmation should not be blank" do
    @job_seeker.attributes = valid_user_attributes.except(:password_confirmation)
    @job_seeker.should have(1).error_on(:password_confirmation)
    @job_seeker.errors[:password_confirmation].should eq(["can't be blank"])
  end
  it "password should have at least six characters" do
    @job_seeker.attributes = valid_user_attributes.with(:password => "1234")
    @job_seeker.should have(2).error_on(:password)
    @job_seeker.errors[:password].should eq(["doesn't match confirmation", "is too short (minimum is 6 characters)"])
  end
  it "password should match the password confirmation" do
    @job_seeker.attributes = valid_user_attributes.with(:password => "123456", 
      :password_confirmation => "1234")
    @job_seeker.should have(1).error_on(:password)
    @job_seeker.errors[:password].should eq(["doesn't match confirmation"])
  end
  it "password and confirmation should have at least six characters" do
    @job_seeker.attributes = valid_user_attributes.with(:password => "1234", :password_confirmation => "1234")
    @job_seeker.should have(1).error_on(:password)
    @job_seeker.errors[:password].should eq(["is too short (minimum is 6 characters)"])
  end
  it "Valid Password" do
    @job_seeker.attributes = valid_user_attributes.with(:password => "123456", :password_confirmation => "123456")
    @job_seeker.should have(0).error_on(:password)
  end
  it "Mobile Number Must be digits only" do
    @job_seeker.attributes = valid_user_attributes.with(:mobile_number => "Bad0123456")
    @job_seeker.should have(1).error_on(:mobile_number)
    @job_seeker.errors[:mobile_number].should eq(["The mobile number should be numeric"])
  end
  it "Mobile Number Should have 10 digits" do
    @job_seeker.attributes = valid_user_attributes.with(:mobile_number => "96546")
    @job_seeker.should have(1).error_on(:mobile_number)
    @job_seeker.errors[:mobile_number].should eq(["is the wrong length (should be 10 characters)"])
  end
  it "Valid Mobile Number" do
    @job_seeker.attributes = valid_user_attributes.with(:mobile_number => "9654699107")
    @job_seeker.should have(0).error_on(:mobile_number)
  end
  it "Gender Should have a value" do
    @job_seeker.attributes = valid_user_attributes.except(:gender)
    @job_seeker.should have(1).error_on(:gender)
    @job_seeker.errors[:gender].should eq(["can't be blank"])
  end
  it "Valid Gender Value" do
    @job_seeker.attributes = valid_user_attributes.with(:gender => "Male")
    @job_seeker.should have(0).error_on(:gender)
  end
end