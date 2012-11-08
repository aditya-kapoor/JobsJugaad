require 'spec_helper'

describe JobsController do
  include ValidAttributeCollection
  before do
    @employer = Employer.new(valid_employer_attributes)
    @employer.email = "testing@testing.com"
    @employer.save
    @job = Job.create(valid_job_attributes)
    @job_seeker = JobSeeker.new(valid_job_seeker_attributes)
    @job_seeker.email = "employer@testing.com"
    @job_seeker.save
  end

  describe "Action Create" do 
    context "When Validations Fail" do 
      def do_create()
        post :create
      end
      before do 
        session[:id] = 1
        session[:user_type] = "employer"
      end
      it "should not create a job" do 
        do_create
        response.should be_success
        response.should render_template "employers/add_job"
      end
    end
    context "When Validations Pass" do
      def do_create
        post :create, :job => valid_job_attributes
      end
      before do 
        session[:id] = 1
        session[:user_type] = "employer"
      end
      it "should create a job" do 
        do_create
        flash[:notice].should eq("A new job has been posted successfully")
        response.should redirect_to(:eprofile)
      end
    end
  end

  describe "Action Edit" do 
    def do_edit
      get :edit, :id => @job.id
    end
    context "When Valid User" do 
      before do
        session[:id] = 1
        session[:user_type] = "employer"
      end
      it "Must Go to the edit page" do
        Job.should_receive(:find_by_id).with(@job.id.to_s).and_return(@job)
        do_edit
        response.should render_template("jobs/edit")
      end
    end
    context "When the user type is job_seeker" do
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
  end

  describe "Action Show" do 
    def do_show
      get :show, :id => @job.id
    end
    context "When Valid User" do
      it "Must show the profile of the job seeker" do
        Job.should_receive(:find_by_id).with(@job.id.to_s).and_return(@job)
        do_show
        response.should be_success
        response.should render_template "jobs/show"
      end
    end
  end

  describe "Action View Applicants" do 
    def do_view_applicants 
      get :view_applicants, :id => @job.id
    end
    context "When USer in not logged in" do 
      before do
        session[:id] = nil
      end
      it "should redirect to the root path" do
        do_view_applicants
        flash[:error].should eq("You are not logged in as employer")
        response.should redirect_to(root_path)
      end
    end
    context "When Incorrect USer is logged in" do 
      before do
        session[:id] = 1
        session[:user_type] = "job_seeker"
      end
      it "should redirect to the root path" do
        do_view_applicants
        flash[:error].should eq("You are not logged in as employer")
        response.should redirect_to(root_path)
      end
    end
    context "When Correct User is Logged in" do 
      before do 
        session[:id] = @employer.id
        session[:user_type] = "employer"
        @employer.jobs << @job
      end
      it "should be able to render the view applicants page" do 
        do_view_applicants
        response.should be_success
      end
    end
    context "When Correct User is trying to access other job's seekers" do 
      def do_view_applicants 
        get :view_applicants, :id => 1000
      end
      before do 
        session[:id] = @employer.id
        session[:user_type] = "employer"
        @employer.jobs << @job
      end
      it "should go to the root path" do 
        do_view_applicants
        flash[:error].should eq("You Don't Own This Job")
        response.should redirect_to(root_path)
      end
    end
  end

  describe "Action Update" do
    def do_update(attributes)
        put :update, :id => @job.id, :job => attributes
    end
    before do
      session[:id] = 1
      session[:user_type] = "employer"
    end
    context "When Validations Pass" do
      it "should be able to update job successfully" do 
        do_update(valid_job_attributes)
        flash[:notice].should eq("Job was successfully updated.")
        response.should redirect_to(eprofile_path)
      end
    end 
    context "When Validations Fail" do
      it "should not be able to update the attributes" do 
        do_update(valid_job_attributes.with(:title => ""))
        response.should be_success
        response.should render_template("jobs/edit")
      end
    end
  end

  describe "Action Destroy" do
    def do_destroy
      delete :destroy, :id => @job.id
    end
    it "should delete the job successfully" do 
      request.stub('referer').and_return(root_path)
      do_destroy
      response.should redirect_to(request.referer)
    end
  end

  describe "Action Search Results" do 
    def do_search_results
      post :search_results, :location => "mumbai", :skills => "php"
    end
    it "should return the jobs according to various criterias" do
      do_search_results
      response.should be_success
    end
  end

  describe "Action Apply" do
    def do_apply
      post :apply, :job_id => 1
    end
    context "When there is no user logged into the system" do
      before do 
        session[:id] = nil
      end
      it "should be redirect along with the value of job to be added into the session" do
        do_apply
        session.should have_key(:job_to_be_added)
        flash[:notice].should eq("Please Login or Register as the job seeker")
        response.should redirect_to(root_path)
      end
    end
    context "When employer is logged into the system" do
      before do 
        session[:id] = 1
        session[:user_type] = "employer"
      end
      it "should be redirect to the root path" do
        do_apply
        flash[:notice].should eq("You are Logged in as employer. Please login as the Job Seeker")
        response.should redirect_to(root_path)
      end
    end
    context "When job seeker is logged in and applies for job" do 
      before do 
        session[:id] = 1
        session[:user_type] = "job_seeker"
        @job_seeker = mock_model(JobSeeker, :id => 1)
        @job = mock_model(Job, :id => 1)

      end
      it "should be able to successfully apply for job" do
        Notifier.stub!(:send_email_to_employer).and_return(@send_email_to_employer)
        @send_email_to_employer.stub!(:deliver).and_return(true)
        do_apply
        response.should redirect_to(profile_path)
      end
    end
  end
end