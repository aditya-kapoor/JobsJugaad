require 'spec_helper'

describe JobApplicationsController do
  include ValidAttributeCollection
  before do
    allow_message_expectations_on_nil()
    session[:id] = 1
    session[:user_type] = "employer"
    Employer.stub!(:find).and_return(@employer)
    JobApplication.stub!(:find).and_return(@job_application)
    @job_application.stub!(:job_seeker).and_return(@job_seeker)
    @job_application.stub!(:job).and_return(@job)
    @job_application.stub!(:job_id).and_return(1)
  end
  context "When the employer calls the job seeker for the interview" do 
    def do_update
      put :update, :id => 1, 
          :job_application => { :interview_on => "27/12/2013", 
            :remarks => "Address and time of interview" }
    end
    before do
      @job_application.stub!(:update_attributes).and_return(true)
      Notifier.stub!(:send_email_for_interview).and_return(@send_email_for_interview)
      @send_email_for_interview.stub!(:deliver).and_return(true)
    end
    it "should be able to call the job seeker for interview" do
      do_update
      response.should redirect_to(view_applicants_job_path(@job_application.job_id))
    end
  end
  context "When the employer calls the job seeker for the interview" do 
    def do_update
      put :update, :id => 1, 
          :job_application => { :interview_on => "27/12/2013", 
            :remarks => "Address and time of interview" }
    end
    before do 
      @job_application.stub!(:update_attributes).and_return(false)
    end
    it "When the attributes fail some validations -> No interview call" do
      do_update
      response.should be_success
      response.should render_template("employers/call_for_interview")
    end
  end
end