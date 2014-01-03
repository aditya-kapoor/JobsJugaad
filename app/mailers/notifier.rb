class Notifier < ActionMailer::Base
  default from: "jobsjugaad@gmail.com"

  def generate_token_link(user, token, url)
    url + "?auth_token=#{token}&email=#{user.email}&type=#{user.class.to_s}"
  end

  def activate_user(user, token)
    @user = user
    @link = generate_token_link(user, token, activate_user_url(:host => "localhost:3000"))
    
    # @link = activate_user_url(:host => "localhost:3000") + "?auth_token=#{user.auth_token}&email=#{user.email}&type=#{user.class.to_s}"
    mail(:to => @user.email, :subject => "Activate Your Account")
  end
  
  def send_password_reset(user, token)
    @user = user
    @link = generate_token_link(user, token, reset_user_password_url(:host => "localhost:3000"))
    # @link = reset_user_password_url(:host => "localhost:3000") + "?auth_token=#{user.auth_token}&email=#{user.email}&type=#{user.class.to_s}"
    mail(:to => @user.email, :subject => "Password Reset Instructions")
  end

  def send_email_for_interview(job_application)
    @job_application = job_application
    @email = JobSeeker.find(job_application.job_seeker_id).email
    @job = Job.find(job_application.job_id)
    mail(:to => @email, :subject => "Call For Interview")
  end

  def send_email_to_employer(job, job_seeker)
    @job = job
    @job_seeker = job_seeker
    mail(:to => @job.employer.email, :subject => "You have received a job application")
  end

  def send_job_alerts(job_seeker, jobs)
    @job_seeker = job_seeker
    @jobs = jobs
    mail(:to => @job_seeker.email, :subject => "Recommended Jobs For You")
  end

  def send_profiles_to_employer(employer, seeker_profiles)
    @employer = employer
    @job_seeker_profiles = seeker_profiles
    mail(:to => @employer.email, :subject => "Some of the Recommended Job Seeker Profiles for you")
  end

end
