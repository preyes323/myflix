class UsersController < ApplicationController
  before_action :require_login, only: %i[show]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      handle_invitation
      
      AppMailer.delay.send_welcome_email(@user)
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

  def new_with_invitation_token
    invitation = Invitation.find_by_token params[:token]
    if invitation
      @user = User.new email: invitation.recipient_email
      @invitation_token = invitation.token
      render 'new'
    else
      redirect_to expired_token_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :email, :full_name)
  end

  def handle_invitation
    if params[:invitation_token] && !params[:invitation_token].empty?
      invitation = Invitation.find_by_token params[:invitation_token]
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end    
  end
end
