class ForgotPasswordsController < ApplicationController
  def new; end

  def create
    flash[:danger] = "Email can not be blank."
    redirect_to forgot_passwords_path
  end
end
