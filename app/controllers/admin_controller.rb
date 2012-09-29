class AdminController < ApplicationController
  def index
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(params[:admin])
    respond_to do |format|
      if @admin.save
        format.html { redirect_to "/admin", notice: "Admin Was Successfully Created.." }
      else
        format.html { render :action => "new" } 
      end
    end
  end 

  def login
    @user = Admin.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      session[:id] = @user.id
      session[:user_type] = "admin"
      redirect_to admin_profile_path
    else
      flash[:error] = "Invalid User and Password Combination"
      render :action => "index"
    end
  end

  def profile
    @admin = Admin.find_by_id(session[:id])
    @jobs = Job.all
    @job_seekers = JobSeeker.all
    @employers = Employer.all
  end

end
