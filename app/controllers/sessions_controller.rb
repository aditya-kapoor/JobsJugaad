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
          @auth_token = BCrypt::Password.create("Tutu")
          @job_seeker.update_attributes(:auth_token => @auth_token)
          @job_seeker.update_attributes(:activated => false)
          @link = activate_user_url + "?auth_token=#{@auth_token}&email=#{@job_seeker.email}&type=JobSeeker"
          Notifier.activate_user(@job_seeker, @link).deliver
          format.html { redirect_to root_path, 
            notice: 'Job Seeker Account was successfully created. A verification mail has been sent to your email..' }
        else
          format.html { render "job_seekers/new.html.erb" }
        end
      end
    else
      @employer = Employer.new(params[:employer])
      respond_to do |format|
        if @employer.save
          @auth_token = BCrypt::Password.create("Tutu")
          @employer.update_attributes(:auth_token => @auth_token)
          @employer.update_attributes(:activated => false)
          @link = activate_user_url + "?auth_token=#{@auth_token}&email=#{@employer.email}&type=Employer"
          Notifier.activate_user(@employer, @link).deliver
          format.html { redirect_to elogin_path, notice: 'Employer Account was successfully created. A verification mail has been sent your mailbox...' }
        else
          format.html { render "employers/new.html.erb" }
        end
      end
    end
  end

  def check_credentials(class_name, redirection)
    class_instance = Object::const_get(class_name)
    @class_object = class_instance.send("find_by_email", params[:email])
    if @class_object && @class_object.authenticate(params[:password])
      if @class_object.activated
        session[:id] = @class_object.id
        session[:user_type] = params[:user_type] #params[:user_type]
        redirect_to redirection
      else
        redirect_to request.referrer, :notice => "You have not activated your account yet!!"
      end
    else
      redirect_to request.referrer, :notice => "Invalid Email and Password Combination"
    end
  end

  def login
    if session[:id].nil?
      if(params[:user_type] == 'job_seeker')
        class_name = :JobSeeker
        redirection = :profile
        check_credentials(class_name, redirection)
      else
        class_name = :Employer
        redirection = :eprofile
        check_credentials(class_name, redirection)
      end
    else
      redirect_to root_url, :notice => "You are already logged into the system"
    end
  end

  def change_password
    begin
      if session[:user_type] == "job_seeker"
        class_name = :JobSeeker
      else
        class_name = :Employer
      end
      @object = Object::const_get(class_name).send("find", session[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url, :notice => "You have already logged out of the system"
    end
  end

  def get_redirection_route(user_type)
    if user_type == "JobSeeker"
      profile_path
    else
      eprofile_path
    end
  end

  def get_params
    if params[:user_type] == "JobSeeker"
      params[:job_seeker]
    else
      params[:employer]
    end
  end

  def update_password
    @object = Object::const_get(params[:user_type]).send("find", session[:id])
    if @object.authenticate(params[:old_password])
      if @object.update_attributes(get_params)
        redirect_to get_redirection_route(params[:user_type]), :notice => "Password has been changed successfully."
      else
        render "change_password.html.erb", :notice => "There Were Some Errors"
      end
    else
      redirect_to request.referrer, :notice => "Invalid Password"
    end
  end

  def forgot_password
    @par = params[:user]  
  end

  def reset_password
    @class = Object::const_get(params[:user])
    @email = params[:email]
    @auth_token = BCrypt::Password.create("Tutu")
    @class_object = @class.send("find_by_email", @email)
    @class_object.update_attributes(:password_reset_token => @auth_token)
    @link = reset_user_password_url + "?auth_token=#{@auth_token}&email=#{@email}&type=#{@class}"
    Notifier.send_password_reset(@email, @link).deliver
    redirect_to root_url, :notice => "Reset Password instructions has been sent"
  end

  def reset_user_password
    @class = Object::const_get(params[:type])
    @class_object = @class.send("find_by_password_reset_token", params[:auth_token])
    if @class_object && @class_object.email == params[:email]
      session[:id] = @class_object.id
      session[:user_type] = (params[:type] == "JobSeeker" ? "job_seeker" : "employer")
      redirect_to set_new_password_path
    else
      redirect_to root_url, :notice => "Your link is incorrect"
    end
  end

  def set_new_password
    @user_type = (session[:user_type] == "job_seeker" ? "JobSeeker" : "Employer")
    @class = Object::const_get(@user_type)
    @class_object = @class.send("find", session[:id])
  end

  def save_new_password
    user_type = session[:user_type] == "job_seeker" ? "JobSeeker" : "Employer"
    @object = Object::const_get(user_type).send("find", session[:id])
  end

  def activate_user
    begin
      @class = Object::const_get(params[:type])
      @user = @class.send("find_by_auth_token", params[:auth_token])
      if @user && @user.email == params[:email]
        @user.update_attributes(:activated => true)
        redirect_to root_url, :notice => "Your Accrount Has been activated successfully.."
      else
        redirect_to root_url, :notice => "Unauthorised Access Detected"
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url, :notice => "There was some error with your link"
    end
  end

  def destroy
    session[:id] = nil
    session[:user_type] = nil
    redirect_to root_url, :notice => "You have been logged out from all the pages of this website"
  end
end
