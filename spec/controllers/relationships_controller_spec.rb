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
      expect(@relationships).to eq(alice.following_relationships)
    end
  end
end
