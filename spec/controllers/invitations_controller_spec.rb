require 'rails_helper'

describe InvitationsController do
  describe 'GET new' do
    it 'sets @invitation to a new invitation' do
      get :new
      expect(assigns(:invitation)).to be_a_new(Invitation)
    end

    it_behaves_like 'require login'    

  end
end
