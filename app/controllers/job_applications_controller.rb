class JobApplicationsController < ApplicationController

  def update
    @job_application = JobApplication.find(params[:id])
     @employer = Employer.find(session[:id])
    @job_seeker = @job_application.job_seeker
    @job = @job_application.job
    respond_to do |format|
      if (@job_application.update_attributes(params[:job_application]))
        Notifier.send_email_for_interview(@job_application).deliver
        format.html { redirect_to view_applicants_path(:id => @job_application.job_id), :notice => "An email has been sent to the job seeker" }
      else
        format.html { render :template => "employers/call_for_interview.html.erb" }
      end
    end
  end 
end
