#FIXME_AB: Should't it be namespaced?
class Admin::AdminController < ApplicationController
  
  def index
  end

  def profile
    @admin = Admin.find_by_id(session[:id])
    @jobs = Job.includes(:employer)
    @employers = Employer.scoped
  end

end
