class RelationshipsController < ApplicationController
  before_action :require_login
  
  def index
    @relationships = current_user.following_relationships
  end

  def create
    user = User.find(params[:leader_id])
    Relationship.create(leader: user, follower: current_user) if current_user.can_follow?(user)
    redirect_to people_path
  end

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if current_user == relationship.follower
    
    redirect_to people_path
  end
end
