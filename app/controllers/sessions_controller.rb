class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:email]

    if user && user.authenticate(params[:password])
      flash[:success] = "Welcome, you've logged in."
      session[:user] = user.id
      redirect_to root_path
    else
      flash.now[:danger] = 'There is something wrong with your username and password.'
      render 'new'
    end
  end
end
