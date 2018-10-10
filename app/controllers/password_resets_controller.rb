class PasswordResetsController < ApplicationController
  def show
    @user = User.find_by_token(params[:id])
    redirect_to expired_token_path and return unless @user
  end

  def expired; end

  def create
  end
end
