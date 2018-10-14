require 'rails_helper'

describe PasswordResetsController do
  describe 'GET show' do
    it 'renders the show template if token is valid' do
      alice = Fabricate(:user)
      alice.update_column(:token, '12345' )
      
      get :show, params: { id: '12345' }
      expect(response).to render_template :show
    end
    
    it 'redirects to the expired token page if the token is not valid' do
      get :show, params: { id: '12345' }
      expect(response).to redirect_to expired_token_path
    end
  end

  describe 'POST create' do
    context 'with valid token' do
      it "updates the user's password" do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')

        post :create, params: { token: '12345', password: 'new_password' }
        expect(alice.reload.authenticate('new_password')).to be_truthy
      end

      it 'redirects to the sign-in page' do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')

        post :create, params: { token: '12345', password: 'new_password' }
        expect(response).to redirect_to(login_path)
      end
      it 'sets the flash success message' do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')

        post :create, params: { token: '12345', password: 'new_password' }
        expect(flash[:success]).to eq('Password successfully reset.')
      end
      
      it 'regenerates the user token' do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')

        post :create, params: { token: '12345', password: 'new_password' }
        expect(alice.reload.token).not_to eq('12345')
      end
    end
    
    context 'with invalid token' do
      it 'redirects to the expired token path' do
        post :create, params: { token: '12345', password: 'new_password' }
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end
