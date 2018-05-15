require 'rails_helper'

RSpec.describe SessionsController do
  describe 'GET new' do
    it 'redirects to home page if logged in' do
      session[:user] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe 'POST create' do
    let(:valid_user) { Fabricate(:user, email: 'foo@bar.com', password: 'password') }

    it 'render the new template if user does not exist' do
      post :create, params: { email: 'baz@qux.com' }
      expect(response).to render_template :new
    end

    it 'renders the new template if valid user provides wrong passowrd' do
      post :create, params: { email: valid_user.email, password: '123' }
      expect(response).to render_template :new
    end

    it 'sets session[:user] if valid user provides correct passowrd' do
      post :create, params: { email: valid_user.email, password: valid_user.password }
      expect(session[:user]).to eq(valid_user.id)
    end
    
    it 'redirects to the home page if valid user provides correct passowrd' do
      post :create, params: { email: valid_user.email, password: valid_user.password }
      expect(response).to redirect_to home_path
    end
  end

  describe 'GET destroy' do
    before do
      session[:user] = Fabricate(:user).id
    end
    
    it 'sets session[:user] to nil' do
      get :destroy
      expect(session[:user]).to be_nil
    end
    
    it 'redirects to root path' do
      get :destroy
      expect(response).to redirect_to root_path
    end
  end
end
