require 'spec_helper'

describe JobApplicationsController do
  include ValidAttributeCollection
  before do
    # allow_message_expectations_on_nil()
    @employer = Employer.new(valid_employer_attributes)
    @employer.email = "testing@testing.com"
    @employer.save
    @job = Job.create(valid_job_attributes)
    @job_application = JobApplication.create(valid_job_application_attributes)
  end
  context "When the employer calls the job seeker for the interview" do 
    def do_update
      put :update, :id => @job_application.id, 
          :job_application => { :interview_on => "27/12/2013", 
            :remarks => "Address and time of interview" }
    end
    before do
      session[:id] = @employer.id
      session[:user_type] = "employer"
      @job_application.stub!(:update_attributes).and_return(true)
      Notifier.stub!(:send_email_for_interview).and_return(@send_email_for_interview)
      @send_email_for_interview.stub!(:deliver).and_return(true)
    end
    it "should be able to call the job seeker for interview" do
      do_update
      response.should redirect_to(view_applicants_job_path(@job_application.job_id))
    end
  end
  # context "When the employer calls the job seeker for the interview & enters incorrect credentials" do 
  #   def do_update
  #     put :update, :id => @job_application.id, 
  #         :job_application => { :interview_on => "27/12/200011", 
  #           :remarks => "" }
  #   end
  #   before do 
  #     session[:id] = @employer.id
  #     session[:user_type] = "employer"
  #     @job_application.stub!(:update_attributes).and_return(false)
  #   end
  #   it "When the attributes fail some validations -> No interview call" do
  #     do_update
  #     response.should be_success
  #     response.should render_template("call_for_interview")
  #   end
  # end
end