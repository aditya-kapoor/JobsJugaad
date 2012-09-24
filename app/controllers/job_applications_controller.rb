class JobApplicationsController < ApplicationController

  def update
    @job_application = JobApplication.find(params[:id])
    respond_to do |format|
      if (@job_application.update_attributes(params[:job_application]))
        Notifier.send_email_for_interview(@job_application).deliver
        format.html { redirect_to view_applicants_path(:id => @job_application.job_id), :notice => "An email has been sent to the job seeker" }
      else
        format.html { redirect_to request.referrer }
      end
    end
  end 
end
