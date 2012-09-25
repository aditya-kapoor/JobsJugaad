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

  def activate_user(user, link)
    @user = user
    @link = link
    mail(:to => @user.email, :subject => "Activate Your Account")
  end

  def send_email_to_employer(job, job_seeker)
    @job = job
    @job_seeker = job_seeker
    mail(:to => @job.employer.email, :subject => "You have received a job application")
  end

end
