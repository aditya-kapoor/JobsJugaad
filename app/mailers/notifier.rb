class Notifier < ActionMailer::Base
  default from: "jobsjugaad@gmail.com"

  def send_password_reset(object, link)
    @email = object.email
    @object = object
    @link = link
    mail(:to => @email, :subject => "Password Reset Instructions")
  end

  def send_email_for_interview(job_application)
    @job_application = job_application
    @email = JobSeeker.find(job_application.job_seeker_id).email
    @job = Job.find(job_application.job_id)
    mail(:to => @email, :subject => "Call For Interview")
  end

  def generate_activation_link(user, token)
    activate_user_url(:host => "localhost:3000") + "?auth_token=#{token}&email=#{user.email}&type=#{user.class.to_s}"
  end

  def activate_user(user, token)
    @user = user
    @link = generate_activation_link(user, token)
    mail(:to => @user.email, :subject => "Activate Your Account")
  end

  def send_email_to_employer(job, job_seeker)
    @job = job
    @job_seeker = job_seeker
    mail(:to => @job.employer.email, :subject => "You have received a job application")
  end

end
