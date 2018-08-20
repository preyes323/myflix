class UsersController < ApplicationController
  before_action :require_login, only: %i[show]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'Your registration is successful'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def index
    redirect_to new_user_path
  end

  def show
    @user = User.find params[:id]
  end

  private

  def user_params
    params.require(:user).permit(:password, :email, :full_name)
  end
end
