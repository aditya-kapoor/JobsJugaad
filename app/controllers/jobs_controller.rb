class JobsController < ApplicationController

  def create
    @employer = Employer.find(session[:id])
    @job = @employer.jobs.build(params[:job])
    respond_to do |format|
      if @job.save
        format.html { redirect_to :eprofile, :notice => "A new job has been posted successfully" }
      else
        format.html { render :template => "employers/add_job.html.erb", :notice => "Job Could not be saved" }
      end
    end
  end

  def edit
    begin
      @job = Job.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to :root, :notice => "Not Authorised to view this page"
    end
  end

  def view_applicants
    @job = Job.find(params[:id])
  end

  def show
    begin
      @job = Job.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to :root, :notice => "Not Authorised to view this page"
    end
  end

  def update
    @job = Job.find(params[:id])

    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.html { redirect_to :eprofile, notice: "Job was successfully updated." }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def search
    if params[:search_type] == "location"
      @jobs = Job.location(params[:location])
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to request.referer, :notice => "Job has been successfully removed" }
    end
  end
end
