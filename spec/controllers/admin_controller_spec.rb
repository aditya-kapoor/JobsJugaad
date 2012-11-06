require 'spec_helper'

describe AdminController do
  before do
    @admin = double(Admin, :id => 1, 
      :email => "admin@jobsjugaad.com",
      :password => "123456")
    @jobs = Job.all
    @employers = Employer.all
  end

  describe "index" do 

    def do_index
    end
    before do 
      @admin = mock Admin
    end
    it "should display a login form" do
      do_index
      response.should be_success
    end
  end

  describe "profile" do
    def do_profile
      get :profile, :id => @admin.id
    end
    it "should find an admin" do
      Admin.should_receive(:find_by_id).and_return(@admin)
      do_profile
    end
    it "should redirect to the profile page" do
      do_profile
      response.should be_success
    end
    it "should fetch all the jobs that are posted" do
      Job.should_receive(:includes).with(:employer).and_return(@jobs)
      do_profile
    end
    it "should fetch all the employers" do
      Employer.should_receive(:scoped).and_return(@employers)
      do_profile
    end
  end
end