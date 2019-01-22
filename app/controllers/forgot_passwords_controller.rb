class ForgotPasswordsController < ApplicationController
  def new; end

  def confirm; end

  def create
    user = User.find_by_email(params[:email])
    if user
      AppMailer.delay.send_forgot_password(user)
      redirect_to forgot_password_confirmation_path
      return
    end

    flash[:danger] = params[:email].blank? ? 'Email can not be blank.' : 'There is no user with that email in the system.'
    redirect_to forgot_password_path
  end
end
