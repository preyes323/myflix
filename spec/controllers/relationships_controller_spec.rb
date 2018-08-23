require 'rails_helper'

RSpec.describe RelationshipsController do
  describe 'GET index' do
    it_behaves_like 'require login' do
      let(:action) { get :index }
    end

    it 'sets @relationships to current_users following relationships' do
      alice = Fabricate(:user)
      set_current_user(alice)

      bob = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: alice)

      get :index
      expect(assigns(:relationships)).to eq(alice.following_relationships)
    end
  end

  describe 'DELETE destroy' do
    it_behaves_like 'require login' do
      let(:action) { delete :destroy, params: { id: 10 } }
    end

    it 'redirects to the people page' do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: alice)

      delete :destroy, params: { id: relationship }
      expect(response).to redirect_to(people_path)
    end
    
    it 'deletes the relationship if the current user is the follower' do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: alice)

      delete :destroy, params: { id: relationship }
      expect(Relationship.count).to eq(0)
    end

    it 'does not delete the relationship if the current user is not the follower' do
      alice = Fabricate(:user)
      cathy = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(cathy)

      relationship = Fabricate(:relationship, leader: bob, follower: alice)

      delete :destroy, params: { id: relationship }
      expect(Relationship.count).to eq(1)
    end
  end

  describe 'POST create' do
    it_behaves_like 'require login' do
      let(:action) { post :create, params: { leader_id: 4 }}
    end

    it 'redirects to the people page' do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)

      post :create, params: { leader_id: bob }
      expect(response).to redirect_to(people_path)
    end
    
    it 'creates a relationship that current user follows the leader' do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)

      post :create, params: { leader_id: bob }
      expect(Relationship.count).to eq(1)
    end
    
    it 'does not create a relationship if the current user already follows the leader' do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      
      Fabricate(:relationship, leader: bob, follower: alice)
      
      post :create, params: { leader_id: bob }
      expect(Relationship.count).to eq(1)      
    end
    
    it 'does not allow one to follow themselves' do
      alice = Fabricate(:user)
      set_current_user(alice)
      
      post :create, params: { leader_id: alice }
      expect(Relationship.count).to eq(0)           
    end    
  end
end
