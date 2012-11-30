class JobApplicationsController < ApplicationController

  def update
    @job_application = JobApplication.includes(:job_seeker).find(params[:id])
    @employer = Employer.find(session[:id])
    @job_seeker = @job_application.job_seeker
    @job = @job_application.job
    respond_to do |format|
      if (@job_application.update_attributes(params[:job_application]))
        Notifier.delay.send_email_for_interview(@job_application)
        format.html { redirect_to view_applicants_job_path(@job_application.job_id), 
                      :notice => "An email has been sent to the job seeker" }
      else
        format.html { render :template => "employers/call_for_interview" }
      end
    end
  end

  def call_for_interview
    @job_application = JobApplication.includes(:job_seeker, [:job => :employer]).find_by_id(params[:id])
  end

  def perform_action
    @job_application = JobApplication.find_by_id(params[:id])
    if @job_application.send(params[:event])
      flash[:notice] = "Action #{params[:event].humanize} has been successfully performed"
    else
      flash[:error] = "This Action (#{params[:event].humanize}) Cannot be Applied"
    end
    redirect_to request.referrer
  end

  def view_applicants
    @job_applications = JobApplication.scoped_by_job_id(params[:id]).where(:state => params[:state])
    render "job_applications/view_#{params[:state]}"
  end
end
