require 'spec_helper'

describe JobApplicationsController do
  include ValidAttributeCollection
  before do
    @job_seeker = double(JobSeeker, :id => 1)
    @job = double(Job, :id => 1)
    @employer = double(Employer, :id => 1)
    @job_application = double(JobApplication, :id => 1)
    @job.stub!(:job_applications).and_return(@job_application)
  end
  context "When the employer calls the job seeker for the interview" do 
    def do_update
      put :update, :id => @job.job_applications.id, 
          :job_application => { :interview_on => "27/12/2013", 
            :remarks => "Address and time of interview" }
    end
    before do 
      @employer.stub!(:jobs).and_return(@job)
      @job_seeker.stub!(:jobs).and_return(@job)
      session[:id] = 1
      session[:user_type] = "employer"
    end
    it "should be able to call the job seeker for interview" do
      # controller.should_receive(:find).with(session[:id]).and_return(@job_application)
      # do_update
      # response.should redirect_to(view_applicants_job_path(@job_application.job_id))
    end
  end
end