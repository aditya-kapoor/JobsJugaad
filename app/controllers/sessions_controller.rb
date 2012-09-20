class SessionsController < ApplicationController

  def save_credentials(class_name, registration_stuff, template)
    class_instance = Object::const_get(class_name)
    @class_object = class_instance.send("new", registration_stuff)
    respond_to do |format|
      if @class_object.save
        format.html { redirect_to root_path, 
          notice: "#{class_name.to_s.capitalize} Account was successfully created. Please login with your new credentials." }
      else
        format.html { render template: template }
      end
    end    
  end

  def register
    if(params[:user_type] == 'job_seeker')
      @job_seeker = JobSeeker.new(params[:job_seeker])
      respond_to do |format|
        if @job_seeker.save
          format.html { redirect_to root_path, notice: 'Job Seeker Account was successfully created. Please login with your new credentials.' }
        else
          format.html { render "job_seekers/new.html.erb" }
        end
      end
      # class_name = :JobSeeker
      # registration_info = params[:job_seeker]
      # template = "job_seekers/new.html.erb"
      # save_credentials(class_name, registration_info, template)
    else
      @employer = Employer.new(params[:employer])
      respond_to do |format|
        if @employer.save
          format.html { redirect_to elogin_path, notice: 'Employer Account was successfully created. Please login with your new credentials.' }
        else
          format.html { render "employers/new.html.erb" }
        end
      end
      # class_name = :Employer
      # registration_info = params[:employer]
      # template = "employers/new.html.erb"
      # save_credentials(class_name, registration_info, template)
    end
  end

  def check_credentials(class_name, redirection)
    class_instance = Object::const_get(class_name)
    @class_object = class_instance.send("find_by_email", params[:email])
    if @class_object && @class_object.authenticate(params[:password])
      session[:id] = @class_object.id
      session[:user_type] = params[:user_type] #params[:user_type]
      redirect_to redirection
    else
      redirect_to request.referrer, :notice => "Invalid Email and Password Combination"
    end
  end

  def login
    if(params[:user_type] == 'job_seeker')
      class_name = :JobSeeker
      redirection = :profile
      check_credentials(class_name, redirection)
    else
      class_name = :Employer
      redirection = :eprofile
      check_credentials(class_name, redirection)
    end
  end

  def destroy
    session[:id] = nil
    session[:user_type] = nil
    redirect_to root_url, :notice => "You have been logged out from all the pages of this website"
  end
end
