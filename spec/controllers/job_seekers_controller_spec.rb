require 'spec_helper'

describe JobSeekersController do
  include ValidAttributeCollection
  before do
    @job_seeker = double(JobSeeker, :id => 1)
  end
  
  describe "Action Show" do
    def do_show
      get :show, :id => @job_seeker.id
    end
    context "When Valid User" do 
      before do
        controller.stub(:is_valid_access?).and_return(true)
      end
      it "Must show the profile of the job seeker" do
        JobSeeker.should_receive(:find).with(@job_seeker.id.to_s).and_return(@job_seeker)
        do_show
        response.should be_success
      end
    end
    context "When Invalid User" do
      context "When session is not set" do
        before do
          session[:id] = nil
        end
        it "Must redirect to the root path" do
          do_show
          flash[:notice].should eq("You are not currently logged into the system...")
          response.should redirect_to(root_path)
        end
      end
      context "When Session is set" do
        context "When the user type is employer is not authorised to see the profile of job seeker" do
          before do 
            session[:id] = 1234
            session[:user_type] = "employer"
            controller.stub(:employer_authorised_to_see_profile?).and_return(false)
          end
          it "must redirect to the root url" do
            do_show
            flash[:notice].should eq("You are not allowed to see this particular profile")
            response.should redirect_to(root_path)
          end
        end
        context "When the user type is employer is authorised to see the profile of job seeker" do
          before do 
            session[:id] = 1234
            session[:user_type] = "employer"
            controller.stub(:employer_authorised_to_see_profile?).and_return(true)
          end
          it "must redirect to the root url" do
            JobSeeker.should_receive(:find).with(@job_seeker.id.to_s).and_return(@job_seeker)
            do_show
            response.should be_success
          end
        end
      end
    end
    context "When Session is set and User Type is job seeker" do
      before do 
        session[:id] = 1234
        session[:user_type] = "job_seeker"
      end
      it "Must redirect to the profile page" do
        JobSeeker.should_receive(:find).with(@job_seeker.id.to_s).and_return(@job_seeker)
        do_show
        response.should be_success
      end
    end
  end

  describe "Action Edit" do 
    def do_edit 
      get :edit, :id => @job_seeker.id
    end
    context "When Valid User" do 
      before do
        session[:id] = 1
        session[:user_type] = "job_seeker"
      end
      it "Must Go to the edit page" do
        JobSeeker.should_receive(:find).with(@job_seeker.id.to_s).and_return(@job_seeker)
        do_edit
        response.should render_template("job_seekers/edit")
      end
    end
    context "When Invalid User" do 
      context "When the user type is employer" do
        before do
          session[:id] = 1
          session[:user_type] = "employer"
          controller.stub(:employer_authorised_to_see_profile?).and_return(true)
        end
        it "should should redirect to the root path" do
          do_edit
          flash[:notice].should eq("You are not authorised to edit this profile")
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
      put :update, :id => @job_seeker.id, :job_seeker => { :name => "testing123456",
       :email => "testing123456@vinsol.com" }
    end
    context "No logged In User" do 
      before do
        session[:id] = nil
      end
      it "should redirect to the root path" do
        do_update
        flash[:notice].should eq("You are not authorised to edit this profile")
        response.should redirect_to(root_path)
      end
    end
    context "Wrong User Type in the system" do
      before do 
        session[:id] = 1
        session[:user_type] = "employer"
      end
      it "should redirect to the root path" do
        do_update
        flash[:notice].should eq("You are not authorised to edit this profile")
        response.should redirect_to(root_path)
      end
    end
    context "Correct User in the system" do
      before do
        session[:id] = 1
        session[:user_type] = "job_seeker"
      end
      it "Should Successfully update the attributes" do
        JobSeeker.should_receive(:find).with(@job_seeker.id.to_s).and_return(@job_seeker)
        @job_seeker.should_receive(:update_attributes).with({"name"=>"testing123456"}).and_return(true)
        do_update
        response.should redirect_to(profile_path)
      end
      it "Should Not Successfully update the attributes" do
        JobSeeker.should_receive(:find).with(@job_seeker.id.to_s).and_return(@job_seeker)
        @job_seeker.should_receive(:update_attributes).with({"name"=>"testing123456"}).and_return(false)
        do_update
        response.should be_success
      end
    end
  end

  describe "Action Upload Asset" do
    def do_upload_asset
      get :upload_asset, :id => session[:id]
    end
    context "No Logged in user" do
      before do
        session[:id] = nil
      end
      it "should redirect to the root path" do
        do_upload_asset
        flash[:notice].should eq("You are not currently logged into the system...")
        response.should redirect_to(root_path)
      end
    end
    context "Valid User Uploads Asset" do
      before do
        session[:id] = 1
        session[:user_type] = "job_seeker"
      end
      it "should upload the asset correctly" do
        JobSeeker.should_receive(:find).with(session[:id]).and_return(@job_seeker)
        @job_seeker.should_receive(:update_attributes).and_return(true)
        do_upload_asset
        flash[:notice].should eq("Your profile has been changed successfully")
        response.should redirect_to(profile_path)
      end
      it "should not be able upload the asset correctly" do
        JobSeeker.should_receive(:find).with(session[:id]).and_return(@job_seeker)
        @job_seeker.should_receive(:update_attributes).and_return(false)
        request.stub('referrer').and_return(root_path)
        do_upload_asset
        flash[:notice].should eq("There Was An Error")
        response.should redirect_to(request.referrer)
      end
    end
  end

  describe "Action New" do
    def do_new
      get :new
    end
    it "Must create a new job seeker" do
      JobSeeker.should_receive(:new).and_return(@job_seeker)
      do_new
      response.should be_success
    end
  end

  describe "Action Profile" do
    def do_profile
      get :profile
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
    context "User Already logged in and tries to change the id of the session" do
      before do
        session[:id] = 100
        session[:user_type] = "job_seeker"
      end
      it "must be redirect to the root path" do 
        do_profile
        flash[:notice].should eq("You have already logged out of the system")
        response.should redirect_to(root_path)
      end

    end
    context "Correct User in the system" do
      before do
        session[:id] = 1
        session[:user_type] = "job_seeker"
      end
      it "Should redirected to the profile page" do
        JobSeeker.should_receive(:find_by_id).with(session[:id]).and_return(@job_seeker)
        do_profile
        response.should be_success 
      end
    end
  end

  describe "Action Download Resume" do
    def do_download_resume
      get :download_resume, :id => @job_seeker.id
    end

    context "User must be logged into the system" do
      before do
        session[:id] = nil
      end
      it "must be able to show the profile page" do
        do_download_resume
        flash[:notice].should eq("You are not currently logged into the system...")
        response.should redirect_to(root_path)
      end
    end
    
    context "Valid User In the system" do 
      before do
        @job_seeker = JobSeeker.create(valid_job_seeker_attributes)
        session[:id] = 1
        session[:user_type] = "employer"
        controller.stub(:employer_authorised_to_see_profile?).and_return(true)
      end
      it "employer should be able to download the resume of job seeker" do
        JobSeeker.should_receive(:find).and_return(@job_seeker)
        @job_seeker.stub!(:send_file).and_return(true)
        do_download_resume
        response.should be_success 
      end
    end
  end

  describe "Action Remove Photo" do
    def do_remove_photo(id)
      get :remove_photo, :id => id
    end
    before do 
      @job_seeker = JobSeeker.create(valid_job_seeker_attributes)
      session[:id] = @job_seeker.id
      session[:user_type] = "job_seeker"
    end
    it "should destroy the profile photo of the job seeker" do
      do_remove_photo(@job_seeker.id)
      response.should redirect_to(profile_path)
    end
  end
end