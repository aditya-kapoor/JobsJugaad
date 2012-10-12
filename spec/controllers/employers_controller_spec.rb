require 'spec_helper'

describe EmployersController do
  include ValidAttributeCollection
  before do
    @employer = double(Employer, :id => 1)
    @job = double(Job, :id => 1)
    @job_seeker = double(JobSeeker, :id => 1)
    @job_application = double(JobApplication, :id => 1)
  end
  
  describe "Action Show" do
    def do_show
      get :show, :id => @employer.id
    end
    context "When Valid User" do
      it "Must show the profile of the employer" do
        Employer.should_receive(:find_by_id).with(@employer.id.to_s).and_return(@employer)
        do_show
        response.should be_success
      end
    end
  end

  describe "Action New" do 
    def do_new
      get :new
    end
    it "should render the registration page for the employer" do
      Employer.should_receive(:new).and_return(@employer)
      do_new
      response.should be_success
      response.should render_template("employers/new")
    end
  end

  describe "Action Edit" do 
    def do_edit 
      get :edit, :id => @employer.id
    end
    context "When Valid User" do 
      before do
        session[:id] = 1
        session[:user_type] = "employer"
      end
      it "Must Go to the edit page" do
        Employer.should_receive(:find).with(@employer.id.to_s).and_return(@employer)
        do_edit
        response.should render_template("employers/edit")
      end
    end
    context "When Invalid User" do 
      context "When the user type is job seeker" do
        before do
          session[:id] = 1
          session[:user_type] = "job_seeker"
        end
        it "should should redirect to the root path" do
          do_edit
          flash[:error].should eq("You are not authorised to do this")
          response.should redirect_to(root_path)
        end
      end
      context "When Session is nil" do
        before do 
          session[:id] = nil
        end
        it "should redirect to the root url" do
          do_edit
          flash[:notice].should eq("You are not currently logged into the system...")
          response.should redirect_to(root_path)
        end
      end
    end
  end

  describe "Action Update" do 
    def do_update
      put :update, :id => @employer.id, :employer => { :name => "testing123456",
       :email => "testing123456@vinsol.com" }
    end
    context "No logged In User" do 
      before do
        session[:id] = nil
      end
      it "should redirect to the root path" do
        do_update
        flash[:notice].should eq("You are not currently logged into the system...")
        response.should redirect_to(root_path)
      end
    end
    context "Wrong User Type in the system" do
      before do 
        session[:id] = 1
        session[:user_type] = "job_seeker"
      end
      it "should redirect to the root path" do
        do_update
        flash[:error].should eq("You are not authorised to do this")
        response.should redirect_to(root_path)
      end
    end
    context "Correct User in the system" do
      before do
        session[:id] = 1
        session[:user_type] = "employer"
      end
      it "Should Successfully update the attributes" do
        Employer.should_receive(:find).with(@employer.id.to_s).and_return(@employer)
        @employer.should_receive(:update_attributes).with({"name"=>"testing123456"}).and_return(true)
        do_update
        response.should redirect_to(eprofile_path)
      end
      it "Should Not Successfully update the attributes" do
        Employer.should_receive(:find).with(@employer.id.to_s).and_return(@employer)
        @employer.should_receive(:update_attributes).with({"name"=>"testing123456"}).and_return(false)
        do_update
        response.should be_success
        response.should render_template("employers/edit")
      end
    end
  end

  describe "Action Profile" do
    def do_profile
      get :profile, :id => @employer.id
    end
    context "User must be logged into the system" do
      before do
        session[:id] = nil
      end
      it "must be able to show the profile page" do
        do_profile
        flash[:notice].should eq("You are not currently logged into the system...")
        response.should redirect_to(root_path)
      end
    end
    context "Correct User in the system" do
      before do
        session[:id] = 1
        session[:user_type] = "employer"
      end
      it "Should redirected to the profile page" do
        Employer.should_receive(:find).with(session[:id]).and_return(@employer)
        do_profile
        response.should be_success 
        response.should render_template("employers/profile")
      end
    end
  end

  describe "Action Add Job" do 
    def do_add_job
      get :add_job, :id => @employer.id
    end
    context "No User Login" do 
      before do 
        session[:id] = nil
      end
      it "should redirect to the root path" do
        do_add_job
        flash[:notice].should eq("You are not currently logged into the system...")
        response.should redirect_to(root_path)
      end
    end
    context "Wrong User Type in the system" do
      before do 
        session[:id] = 1
        session[:user_type] = "job_seeker"
      end
      it "should redirect to the root path" do
        do_add_job
        flash[:error].should eq("You are not authorised to do this")
        response.should redirect_to(root_path)
      end
    end
    context "When Valid User" do
      before do
        session[:id] = 1
        session[:user_type] = "employer"
      end
      it "Must Go to the add job page" do
        Employer.should_receive(:find).with(session[:id]).and_return(@employer)
        x = []
        @employer.stub!(:jobs).and_return(x)
        x.stub!(:build).and_return(@job)
        do_add_job
        response.should render_template("employers/add_job")
      end
    end
  end

  describe "Action Call For Interview" do 
    def do_call_for_interview
      get :call_for_interview, :job_id => @job.id
    end
    context "No User Login" do 
      before do 
        session[:id] = nil
      end
      it "should redirect to the root path" do
        do_call_for_interview
        flash[:notice].should eq("You are not currently logged into the system...")
        response.should redirect_to(root_path)
      end
    end
    context "Correct User Login" do
      before do
        session[:id] = 1
        session[:user_type] = "employer"
      end
      it "should render the call for interview page" do
        Employer.should_receive(:find).with(session[:id]).and_return(@employer)
        JobSeeker.should_receive(:find).and_return(@job_seeker)
        Job.should_receive(:find).and_return(@job)
        JobApplication.stub!(:find_by_job_seeker_id_and_job_id).and_return(@job_application)
        do_call_for_interview
        response.should be_success
        response.should render_template("employers/call_for_interview")
      end
    end
  end

  describe "Action Remove Photo" do
    def do_remove_photo(id)
      get :remove_photo, :id => id
    end
    before do
      session[:id] = @employer.id
      session[:user_type] = "employer"
    end
    it "should destroy the profile photo of the job seeker" do
      Employer.stub!(:find).and_return(@employer)
      x = []
      @employer.stub!(:photo).and_return(x)
      x.stub!(:destroy).and_return(true)
      @employer.stub!(:update_attribute).and_return(true)
      do_remove_photo(@employer.id)
      response.should redirect_to(eprofile_path)
    end
  end

end