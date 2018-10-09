class AppMailer < ApplicationMailer
  default from: 'info@myflix.com'
  
  def send_welcome_email(user)
    @user = user
    mail to: user.email, subject: 'Welcome to MyFlix!'
  end

  def send_forgot_password(user)
    @user = user
    mail to: @user.email, subject: 'Please reset your password'
  end
end
