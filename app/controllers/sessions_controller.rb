class SessionsController < ApplicationController

  before_filter :is_valid_user?, :only => [:change_password]

  def save_credentials(class_name, registration_stuff, template)
    @class_object = class_name.constantize.new(registration_stuff)
    respond_to do |format|
      if @class_object.save
        format.html { redirect_to root_path, 
          notice: "#{class_name.to_s.capitalize} Account was successfully created. 
          A verification mail has been sent to your email so that we can identify you.." }
      else
        format.html { render template: template }
      end
    end    
  end

  def register
    if(params[:user_type] == 'job_seeker')
      class_name = "JobSeeker"
      registration_stuff = params[:job_seeker]
      template = "job_seekers/new.html.erb"
      save_credentials(class_name, registration_stuff, template)
    else
      class_name = "Employer"
      registration_stuff = params[:employer]
      template = "employers/new.html.erb"
      save_credentials(class_name, registration_stuff, template)
    end
  end

  def check_for_activation(class_object, redirection)
    if class_object.activated
      session[:id] = @class_object.id
      session[:user_type] = params[:user_type] #params[:user_type]
      redirect_to redirection
    else
      redirect_to request.referrer, :notice => "You have not activated your account yet!!"
    end
  end

  def check_credentials(class_name, redirection)
    @class_object = class_name.constantize.find_by_email(params[:email])
    if @class_object && @class_object.authenticate(params[:password])
      check_for_activation(@class_object, redirection)
    else
      flash[:error] = "Invalid Email and Password Combination"
      redirect_to request.referrer
    end
  end

  def login
    if session[:id].nil?
      if(params[:user_type] == 'job_seeker')
        class_name = "JobSeeker"
        redirection = :profile
        check_credentials(class_name, redirection)
      else
        class_name = "Employer"
        redirection = :eprofile
        check_credentials(class_name, redirection)
      end
    else
      redirect_to root_url, :notice => "You are already logged into the system"
    end
  end

  def activate_user
    @user = params[:type].constantize.find_by_auth_token(params[:auth_token])
    if @user && @user.email == params[:email]
      @user.update_attributes(:activated => true)
      notice = "Your Accrount Has been activated successfully.."
    else
      notice = "There Was A Problem With Your Link"
    end
    redirect_to root_url, :notice => notice
  end

  def get_class_name
    if session[:user_type] == "job_seeker"
      "JobSeeker"
    else
      "Employer"
    end
  end

  def get_params_class
    if params[:job_seeker]
      "JobSeeker"
    else
      "Employer"
    end
  end

  def is_valid_user?
    unless params[:id].to_s == session[:id].to_s
      flash[:error] = "You are not authorised to do this"
      redirect_to get_redirection_route
    end 
  end

  def change_password
    @object = get_class_name.constantize.find(params[:id])
  end

  def update_password
    @object = params[:user_type].constantize.find(session[:id])
    if @object.authenticate(params[:old_password])
      if @object.update_attributes(get_params)
        redirect_to get_redirection_route, :notice => "Password has been changed successfully."
      else
        flash[:error] = "There Were Some Errors"
        render "change_password.html.erb"
      end
    else
      flash[:error] = "Invalid Password"
      redirect_to request.referrer
    end
  end

  def get_redirection_route
    if session[:user_type] == "job_seeker"
      profile_path
    else
      eprofile_path
    end
  end

  def forgot_password
    @par = params[:user]  
  end

  def reset_password
    auth_token = BCrypt::Password.create("Tutu")
    @class_object = params[:user].constantize.find_by_email(params[:email])
    unless @class_object.nil?
      @class_object.update_attributes(:password_reset_token => auth_token)
      Notifier.send_password_reset(@class_object, auth_token).deliver
      redirect_to root_url, :notice => "Reset Password instructions has been sent to your mail account"
    else
      flash[:error] = "There Was An Error With your email"
      redirect_to root_url
    end
  end

  def reset_user_password
    @class_object = params[:type].constantize.find_by_password_reset_token(params[:auth_token])
    if @class_object && @class_object.email == params[:email]
      # @id = @class_object.id
      # @user_type = (params[:type] == "JobSeeker" ? "job_seeker" : "employer")

      session[:id] = @class_object.id
      session[:user_type] = (params[:type] == "JobSeeker" ? "job_seeker" : "employer")
      redirect_to set_new_password_path
    else
      redirect_to root_url, :notice => "Your link is incorrect"
    end
  end

  def set_new_password
    @class_object = determine_class_name.constantize.find(session[:id])
  end

  def save_new_password
    @class_object = determine_class_name.constantize.find(session[:id])
    if @class_object.update_attributes(params[session[:user_type].to_sym])
      @class_object.update_attributes(:password_reset_token => nil)
      session[:id] = nil
      session[:user_type] = nil
      redirect_to root_url, :notice => "Your Password has been reset successfully..Login now!!"
    else
      render :action => :set_new_password 
    end
  end

  def determine_class_name
    if session[:user_type] == "job_seeker" 
      "JobSeeker"
    else
     "Employer"
   end
  end

  def get_params
    if params[:user_type] == "JobSeeker"
      params[:job_seeker]
    else
      params[:employer]
    end
  end

  def destroy #logout
    session[:id] = nil
    session[:user_type] = nil
    redirect_to root_url, :notice => "You have been logged out from all the pages of this website"
  end
end
