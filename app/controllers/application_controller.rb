class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user])
  end

  def logged_in?
    current_user != nil
  end

  def require_login
    not_allowed unless logged_in?
  end

  private

  def not_allowed
    flash[:danger] = 'You are not allowed to do that'
    redirect_to root_path
  end
end
