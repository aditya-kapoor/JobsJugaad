class EmployersController < ApplicationController
  def authenticate
    @employer = Employer.find_by_email(params[:email])
    if @employer && @employer.authenticate(params[:password])
      session[:employer_id] = @employer.id
      redirect_to :eprofile
    else
      redirect_to request.referrer, :notice => "Invalid Email and Password Combination"
    end
  end

  def new
    @employer = Employer.new
  end

  def create
    @employer = Employer.new(params[:employer])
    respond_to do |format|
      if @employer.save
        format.html { redirect_to elogin_path, notice: 'Employer Account was successfully created. Please login with your new credentials.' }
        format.json { render json: elogin_path, status: :created, location: @employer }
      else
        format.html { render action: "new" }
        format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end

  def logout
    session[:employer_id] = nil
    redirect_to root_url, :notice => "You have been successfully logged out"
  end

end
