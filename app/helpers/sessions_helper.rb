module SessionsHelper

  def check_for_activation(class_object, redirection)
    if class_object.activated
      session[:id] = @class_object.id
      session[:user_type] = params[:user_type] #params[:user_type]
      redirect_to redirection
    else
      flash[:error] = "You have not activated your account yet!!"
      redirect_to request.referrer
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

  def get_class_name
    case session[:user_type]
    when "job_seeker"
      "JobSeeker"
    when "employer"
      "Employer"
    when "admin"
      "Admin"
    end
  end

  def get_params_class
    if params[:job_seeker]
      "JobSeeker"
    else
      "Employer"
    end
  end

  def get_redirection_route
    case session[:user_type]
    when "job_seeker"
      profile_path
    when "employer"
      eprofile_path
    when "admin"
      admin_profile_path
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
    case params[:user_type]
    when "JobSeeker"
      params[:job_seeker]
    when "Employer"
      params[:employer]
    when "Admin"
      params[:admin]
    end
  end
  
end
