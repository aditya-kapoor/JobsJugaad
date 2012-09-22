class Notifier < ActionMailer::Base
  default from: "jobsjugaad@gmail.com"

  def send_password_reset(email, link)
    @email = email
    @link = link
    mail(:to => @email, :subject => "Password Reset Instructions")
  end

  def activate_user(user, link)
    @user = user
    @link = link
    mail(:to => @user.email, :subject => "Activate Your Account")
  end
end
