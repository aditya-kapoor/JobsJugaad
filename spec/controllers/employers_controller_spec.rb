require 'spec_helper'

describe EmployersController do
  include ValidAttributeCollection
  before do
    @employer = double(Employer, :id => 1)
    @job = double(Job, :id => 1)
    @job_seeker = double(JobSeeker, :id => 1)
    @job_application = double(JobApplication, :id => 1)
  end
  before(:each) do
    Employer.stub!(:find_by_id).and_return(@employer)
  end

  describe "Action Show" do
    def do_show(id = @employer.id)
      get :show, :id => id
    end
    context "When No employer exists" do
      it "must redirect to the root path" do
        Employer.should_receive(:find_by_id).and_return(false)
        do_show(-1)
        response.should redirect_to(root_path)
      end
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
    def do_edit(id = @employer.id) 
      get :edit, :id => id
    end
    context "When Valid User" do 
      before do
        session[:id] = 1
        session[:user_type] = "employer"
      end
      it "Must Go to the edit page" do
        Employer.should_receive(:find_by_id).with(@employer.id.to_s).and_return(@employer)
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
        Employer.should_receive(:find_by_id).and_return(@employer)
      end
      it "Should Successfully update the attributes" do
        Employer.should_receive(:find_by_id).with(@employer.id.to_s).and_return(@employer)
        @employer.should_receive(:update_attributes).with({"name"=>"testing123456", "email"=>"testing123456@vinsol.com"}).and_return(true)
        do_update
        response.should redirect_to(eprofile_path)
      end
      it "Should Not Successfully update the attributes" do
        Employer.should_receive(:find_by_id).with(@employer.id.to_s).and_return(@employer)
        @employer.should_receive(:update_attributes).with({"name"=>"testing123456", "email"=>"testing123456@vinsol.com"}).and_return(false)
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
        Employer.should_receive(:find_by_id).with(session[:id]).and_return(@employer)
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
        x = []
        @employer.should_receive(:jobs).and_return(x)
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
    context "Authorised Employer" do
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
      Employer.stub!(:find_by_id).and_return(@employer)
      x = []
      @employer.stub!(:photo).and_return(x)
      x.stub!(:destroy).and_return(true)
      @employer.stub!(:update_attribute).and_return(true)
      do_remove_photo(@employer.id)
      response.should redirect_to(eprofile_path)
    end
  end

  describe "Action Post to Twitter" do
    def do_post_to_twitter(id)
      get :post_to_twitter, :id => id
    end
    context "When There is no logged in user" do 
      before do 
        session[:id] = nil
      end
      it "should redirect to the root path" do
        do_post_to_twitter(1)
        response.should redirect_to(root_path)
      end
    end
    context "When logged in user is incorrect" do 
      before do 
        session[:id] = 1
        session[:user_type] = "job_seeker"
      end
      it "should redirect to the root path" do
        do_post_to_twitter(1)
        response.should redirect_to(root_path)
      end
    end
    context "When logged in user is correct" do 
      before do 
        session[:id] = 1
        session[:user_type] = "employer"
        Employer.stub!(:find_by_id).and_return(@employer)
        Job.stub!(:find_by_id).and_return(@job)
      end
      it "should redirect to the authorize url" do
        request_token = {}
        @employer.should_receive(:check_for_existing_tokens).and_return(nil)
        @employer.should_receive(:generate_request_token).and_return(request_token)
        request_token.stub!(:authorize_url).and_return(root_path)
        do_post_to_twitter(1)
        response.should redirect_to(request_token.authorize_url)
      end
    end
    context "When logged in user is correct" do 
      before do 
        session[:id] = 1
        session[:user_type] = "employer"
        Employer.stub!(:find_by_id).and_return(@employer)
        Job.stub!(:find_by_id).and_return(@job)
        @job.stub!(:description).and_return("abc")
      end
      it "should post the tweet directly" do
        request_token = {}
        xyz = @employer.stub!(:check_for_existing_tokens).and_return(["XYZ", "PQR"])
        token, secret = xyz.call
        @employer.stub!(:configure_twitter).and_return(true)
        controller.stub!(:update_tweet_on_timeline)
        do_post_to_twitter(1)
        response.should redirect_to(eprofile_path)
        flash[:notice].should eq("Successfully Tweeted Job Posting")
      end
    end
  end

  describe "Action Post Tweet" do
    def do_post_tweet(id, oauth = "123456")
      get :post_tweet, :id => id, :oauth_verifier => oauth
    end
    context "When There is no logged in user" do 
      before do 
        session[:id] = nil
      end
      it "should redirect to the root path" do
        do_post_tweet(1)
        response.should redirect_to(root_path)
      end
    end
    context "When logged in user is incorrect" do 
      before do 
        session[:id] = 1
        session[:user_type] = "job_seeker"
      end
      it "should redirect to the root path" do
        do_post_tweet(1)
        response.should redirect_to(root_path)
      end
    end
    context "When logged in user is correct" do 
      before do 
        session[:id] = 1
        session[:user_type] = "employer"
        Employer.stub!(:find_by_id).and_return(@employer)
        Job.stub!(:find_by_id).and_return(@job)
        @job.stub!(:description).and_return("abc")
      end
      it "should be able to post tweet on his timeline" do
        access_token = {}
        @employer.stub!(:generate_access_token).and_return(access_token)
        token = access_token.stub!(:token).and_return("token")
        secret = access_token.stub!(:secret).and_return("secret")
        @employer.stub!(:save_token).and_return(true)
        @employer.stub!(:configure_twitter).and_return(true)
        controller.stub!(:update_tweet_on_timeline).and_return(true)
        do_post_tweet(1)
        flash[:notice].should eq("Successfully Tweeted Job Posting")
        response.should redirect_to(eprofile_path)
      end
    end
  end

  # describe "Action Destroy" do
  #   def do_destroy(id = @employer.id)
  #     delete :destroy, :id => id
  #   end
  #   before do
  #     session[:id] = 1
  #     session[:user_type] = "employer" 
  #     request.stub('referrer').and_return(root_path)
  #   end
  #   it "should destroy the employer and all its associations" do
  #     Employer.should_receive(:find_by_id).and_return(@employer)
  #     @employer.stub!(:destroy).and_return(true)
  #     do_destroy
  #     flash[:notice].should eq("flklkflk")
  #     response.should redirect_to request.referrer
  #   end
  # end
end