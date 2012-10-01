require 'spec_helper'

module EmployerSpecHelper
  def valid_user_attributes
  { :name => "Testing Employer", 
    :email => "employer@testing.com",
    :website => "http://testing.com",
    :description => "This is the test description for the testing employer",
    :password => "123456",
    :password_confirmation => "123456",
    :activated => true,
    :photo_file_name => "photo.jpeg",
    :photo_content_type => "image/jpeg",
    :photo_file_size => 17185,
    :photo_updated_at => Time.now
  }
  end
end
describe Employer do
  include EmployerSpecHelper
  before(:each) do
    @employer = Employer.new
  end

  it "It can be instantiated" do
    Employer.new.should be_an_instance_of(Employer)
  end
  it "cannot be saved successfully" do
    Employer.create.should_not be_persisted
  end
  it "name should not be nil" do
    @employer.attributes = valid_user_attributes.except(:name)
    @employer.should have(1).error_on(:name)
    @employer.errors[:name].should eq(["can't be blank"])
  end
  it "Valid Name" do
    @employer.attributes = valid_user_attributes.only(:name)
    @employer.should have(0).error_on(:name)
  end
  it "Invalid Email Format" do
    @employer.attributes = valid_user_attributes.with(:email => "abc@cde")
    @employer.should have(1).error_on(:email)
    @employer.errors[:email].should eq(["Doesn't Looks the correct email ID"])
  end
  it "Email Should not be null" do
    @employer.attributes = valid_user_attributes.except(:email)
    @employer.should have(1).error_on(:email)
    @employer.errors[:email].should eq(["can't be blank"])
  end
  it "Email must be unique" do
    @employer.attributes = valid_user_attributes
    @employer.save
    @employer1 = Employer.new()
    @employer1.attributes = valid_user_attributes
    @employer1.save
    @employer1.should have(1).error_on(:email)
    @employer1.errors[:email].should eq(["has already been taken"])
  end
  it "Valid Email" do
    @employer.attributes = valid_user_attributes.only(:email)
    @employer.should have(0).error_on(:email)
  end
  it "password should not be blank" do
    @employer.attributes = valid_user_attributes.with(:password => "")
    @employer.should have(2).error_on(:password)
    @employer.errors[:password].should eq(["doesn't match confirmation", "can't be blank"])
  end
  it "password confirmation should not be blank" do
    @employer.attributes = valid_user_attributes.except(:password_confirmation)
    @employer.should have(1).error_on(:password_confirmation)
    @employer.errors[:password_confirmation].should eq(["can't be blank"])
  end
  it "password should have at least six characters" do
    @employer.attributes = valid_user_attributes.with(:password => "1234")
    @employer.should have(2).error_on(:password)
    @employer.errors[:password].should eq(["doesn't match confirmation", "is too short (minimum is 6 characters)"])
  end
  it "password should match the password confirmation" do
    @employer.attributes = valid_user_attributes.with(:password => "123456", :password_confirmation => "1234")
    @employer.should have(1).error_on(:password)
    @employer.errors[:password].should eq(["doesn't match confirmation"])
  end
  it "password and confirmation should have at least six characters" do
    @employer.attributes = valid_user_attributes.with(:password => "1234", :password_confirmation => "1234")
    @employer.should have(1).error_on(:password)
    @employer.errors[:password].should eq(["is too short (minimum is 6 characters)"])
  end
  it "Valid Password" do
    @employer.attributes = valid_user_attributes.with(:password => "123456", :password_confirmation => "123456")
    @employer.should have(0).error_on(:password)
  end
  it "Must Have a Valid Profile Photo" do
    @employer.attributes = valid_user_attributes.with(:photo_file_name => "photo.pdf")
    @employer.should have(1).error_on(:photo_file_name)
    @employer.errors[:photo_file_name].should eq(["Invalid Photo Format: Allowed Formats Are Only in jpeg, jpg, png, ico and gif"])
  end
  it "The size of the Photo must be less than 6 MB" do
    @employer.attributes = valid_user_attributes.with(:photo_file_size => 9999999999)
    @employer.should have(1).error_on(:photo_file_size)
    @employer.errors[:photo_file_size].should eq(["Must be less than 6 MB"])
  end
  it "Has Valid Profile Photo" do
    @employer.attributes = valid_user_attributes.with(:photo_file_name => "photo.jpg")
    @employer.should have(0).error_on(:photo_file_name)
  end
  
end