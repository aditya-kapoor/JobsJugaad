require_relative '../../lib/sessions_controller_helper_functions'
class SessionsController < ApplicationController

  include SessionsControllerHelperFunctions

  before_filter :is_valid_user?, :only => [:change_password]
  before_filter :decode_user_type, :only => [:login, :register]

  def decode_user_type
    params[:user_type] = Base64.decode64(params[:user_type])
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

  def login
    if session[:id].nil?
      case params[:user_type]
      when "job_seeker"
        class_name = "JobSeeker"
        redirection = :profile
        check_credentials(class_name, redirection)
      when "employer"    
        class_name = "Employer"
        redirection = :eprofile
        check_credentials(class_name, redirection)        
      when "admin"
        class_name = "Admin"
        redirection = :admin_profile
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

  def is_valid_user?
    unless params[:id].to_s == session[:id].to_s
      flash[:error] = "You are not authorised to do this"
      redirect_to root_url
    end 
  end

  def change_password
    @object = get_class_name.constantize.find(params[:id])
  end

  def update_password
    @object = params[:user_type].constantize.find(session[:id])
    if @object.authenticate(params[:old_password])
      save_password
    else
      flash[:error] = "Invalid Password"
      redirect_to request.referrer
    end
  end

  def forgot_password
    @par = params[:user]
  end

  def reset_password # forgot password credentials are sent to this action....
    @class_object = params[:user].constantize.find_by_email(params[:email])
    auth_token = BCrypt::Password.create("Tutu")
    unless @class_object.nil?
      @class_object.update_attributes(:password_reset_token => auth_token)
      Notifier.send_password_reset(@class_object, auth_token).deliver
      flash[:notice] = "Reset Password instructions has been sent to your mail account"
    else
      flash[:error] = "There Was An Error With your email"
    end
    redirect_to root_url
  end

  def reset_user_password
    @class_object = params[:type].constantize.find_by_password_reset_token(params[:auth_token])
    if @class_object && @class_object.email == params[:email]
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
      reset_session
      redirect_to root_url, :notice => "Your Password has been reset successfully..Login now!!"
    else
      render :action => :set_new_password 
    end
  end

  def destroy #logout
    reset_session
    redirect_to root_url, :notice => "You have been logged out from all the pages of this website"
  end
end
