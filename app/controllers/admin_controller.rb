#FIXME_AB: Should't it be namespaced?
class AdminController < ApplicationController
  
  def index
  end

  def profile
    @admin = Admin.find_by_id(session[:id])
    @jobs = Job.all
    @employers = Employer.all
  end

end
