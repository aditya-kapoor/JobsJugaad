require 'spec_helper'

module SkillSpecHelper
  def valid_skill_attributes
  { :name => "php"
  }
  end
end

describe Skill do 
  include SkillSpecHelper
  before(:each) do
    @skill = Skill.new
  end
  it "name should not be empty" do
    @skill.attributes = valid_skill_attributes.except(:name)
    @skill.should have(1).error_on(:name)
    @skill.errors[:name].should eq(["can't be blank"])
  end
  it "should have unique skill value" do
    @skill.attributes = valid_skill_attributes
    @skill.save
    @skill1 = Skill.create(:name => "php")
    @skill1.save
    @skill1.should have(1).error_on(:name)
    @skill1.errors[:name].should eq(["has already been taken"])
  end
  it "Valid Skill" do
    @skill.attributes = valid_skill_attributes.with(:name => "java")
    @skill.should have(0).error_on(:name)
  end
end