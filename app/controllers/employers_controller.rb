class EmployersController < ApplicationController
  
  def edit
    @employer = Employer.find(session[:id])
  end

  def update
    @employer = Employer.find(params[:id])

    respond_to do |format|
      if @employer.update_attributes(params[:employer])
        format.html { redirect_to eprofile_url, notice: "Employer Profile was successfully updated." }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def remove_photo
    @employer = Employer.find(session[:id])
    @employer.photo.destroy
    @employer.update_attribute(:photo, nil)
    redirect_to eprofile_path
  end

  def new
    @employer = Employer.new
  end

  def add_job
    @employer = Employer.find(session[:id])
    @job = @employer.jobs.build
  end
  
end
