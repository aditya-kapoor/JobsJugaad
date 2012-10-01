require 'spec_helper'

module JobSpecHelper
  def valid_job_attributes
  { :title => "Testing Job", 
    :description => "This is the description of the testing jobs which is specifically used for testing in the RSpec",
    :location => "Delhi",
    :salary_min => 15000,
    :salary_max => 25000,
    :salary_type => "pm",
    :skill_name => "php, java"
  }
  end
end

describe Job do
  include JobSpecHelper
  before(:each) do
    @job = Job.new
  end
  it "Must Have A title" do
    @job.attributes = valid_job_attributes.except(:title)
    @job.should have(1).error_on(:title)
    @job.errors[:title].should eq(["can't be blank"])
  end
  it "Valid Title" do
    @job.attributes = valid_job_attributes.with(:title => "Testing Post")
    @job.should have(0).error_on(:title)
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