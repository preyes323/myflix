class PasswordResetsController < ApplicationController
  def show
    @user = User.find_by_token(params[:id])
    redirect_to expired_token_path and return unless @user
  end

  def expired; end

  def create
    user = User.find_by_token(params[:token])
    redirect_to expired_token_path and return unless user
    
    user.password = params[:password]
    user.password_confirmation = params[:password]
    user.send(:generate_token)
    user.save
    flash[:success] = 'Password successfully reset.'

    redirect_to login_path
  end
end
