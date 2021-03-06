require 'spec_helper'

describe Admin do
  include ValidAttributeCollection
  before(:each) do
    @admin = Admin.new
  end
  describe "Validations" do 

    it "It can be instantiated" do
      Admin.new.should be_an_instance_of(Admin)
    end
    it "cannot be saved successfully" do
      Admin.create.should_not be_persisted
    end
    it "name should not be nil" do
      @admin.attributes = valid_admin_attributes.except(:name)
      @admin.should have(1).error_on(:name)
      @admin.errors[:name].should eq(["Please Enter A Valid Name"])
    end
    it "Valid Name" do
      @admin.attributes = valid_admin_attributes.only(:name)
      @admin.should have(0).error_on(:name)
    end
    it "Invalid Email Format" do
      @admin.attributes = valid_admin_attributes.with(:email => "abc@cde")
      @admin.should have(1).error_on(:email)
      @admin.errors[:email].should eq(["Doesn't Looks the correct email ID"])
    end
    it "Email Should not be null" do
      @admin.attributes = valid_admin_attributes.except(:email)
      @admin.should have(1).error_on(:email)
      @admin.errors[:email].should eq(["Please Enter A Valid Email"])
    end
    it "Email must be unique" do
      @admin.attributes = valid_admin_attributes
      @admin.save
      @admin1 = Admin.new()
      @admin1.attributes = valid_admin_attributes
      @admin1.save
      @admin1.should have(1).error_on(:email)
      @admin1.errors[:email].should eq(["This Email has already been taken"])
    end
    it "Valid Email" do
      @admin.attributes = valid_admin_attributes.only(:email)
      @admin.should have(0).error_on(:email)
    end
    # it "password should not be blank" do
    #   @job_seeker.attributes = valid_admin_attributes.except(:password)
    #   @job_seeker.should have(2).error_on(:password)
    #   @job_seeker.errors[:password].should eq(["doesn't match confirmation", "can't be blank"])
    # end
    it "password confirmation should not be blank" do
      @admin.attributes = valid_admin_attributes.except(:password_confirmation)
      @admin.should have(1).error_on(:password_confirmation)
      @admin.errors[:password_confirmation].should eq(["Please Enter A Valid Password confirmation"])
    end
    it "password should have at least six characters" do
      @admin.attributes = valid_admin_attributes.with(:password => "1234")
      @admin.should have(2).error_on(:password)
      @admin.errors[:password].should eq(["Does not match its confirmation", "The Password must have at least 6 chars"])
    end
    it "password should match the password confirmation" do
      @admin.attributes = valid_admin_attributes.with(:password => "123456", 
        :password_confirmation => "1234")
      @admin.should have(1).error_on(:password)
      @admin.errors[:password].should eq(["Does not match its confirmation"])
    end
    it "password and confirmation should have at least six characters" do
      @admin.attributes = valid_admin_attributes.with(:password => "1234", :password_confirmation => "1234")
      @admin.should have(1).error_on(:password)
      @admin.errors[:password].should eq(["The Password must have at least 6 chars"])
    end
    it "Valid Password" do
      @admin.attributes = valid_admin_attributes.with(:password => "123456", :password_confirmation => "123456")
      @admin.should have(0).error_on(:password)
    end
  end
end