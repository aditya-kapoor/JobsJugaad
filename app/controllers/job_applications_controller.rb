class JobApplicationsController < ApplicationController

  def update
    @job_application = JobApplication.find(params[:id])
    @employer = Employer.find(session[:id])
    @job_seeker = @job_application.job_seeker
    @job = @job_application.job
    respond_to do |format|
      if (@job_application.update_attributes(params[:job_application]))
        Notifier.send_email_for_interview(@job_application).deliver
        format.html { redirect_to view_applicants_job_path(@job_application.job_id), 
                      :notice => "An email has been sent to the job seeker" }
      else
        format.html { render :template => "employers/call_for_interview" }
      end
    end
  end 

  def rejected
    @job_application = JobApplication.find_by_job_id_and_job_seeker_id(params[:job_id], params[:seeker_id]).fire_state_event(:rejected)
    redirect_to request.referrer
  end

  def shortlisted
    @job_application = JobApplication.find_by_job_id_and_job_seeker_id(params[:job_id], params[:seeker_id]).fire_state_event(:shortlist)
    redirect_to request.referrer
  end

  def calling_for_interview
    @job_application = JobApplication.find_by_job_id_and_job_seeker_id(params[:job_id], params[:seeker_id]).fire_state_event(:calling_for_interview)
    redirect_to request.referrer
  end

  def called_for_interview
    @job_application = JobApplication.find_by_job_id_and_job_seeker_id(params[:job_id], params[:seeker_id]).fire_state_event(:called_for_interview)
    redirect_to request.referrer
  end

  def accepted_offer
    @job_application = JobApplication.find_by_job_id_and_job_seeker_id(params[:job_id], params[:seeker_id]).fire_state_event(:accepted_offer)
    redirect_to request.referrer
  end

  def rejected_offer
    @job_application = JobApplication.find_by_job_id_and_job_seeker_id(params[:job_id], params[:seeker_id]).fire_state_event(:rejected_offer)
    redirect_to request.referrer
  end

  def view_shortlisted
    @job_applications = JobApplication.scoped_by_job_id(params[:job_id]).where(:state => "shortlisted")
  end

  def view_called_for_interview
    @job_applications = JobApplication.scoped_by_job_id(params[:job_id]).where(:state => "called_for_interview")
  end

  def view_given_offer
    @job_applications = JobApplication.scoped_by_job_id(params[:job_id]).where(:state => "given_offer")
  end

  def invalid_action
    @job_application = JobApplication.find_by_job_id_and_job_seeker_id(params[:job_id], params[:seeker_id])
    unless @job_application.send(params[:event].to_s)
      flash[:error] = "This Action (#{params[:event].humanize}) Cannot be Applied"
    end
    redirect_to request.referrer
  end
end
