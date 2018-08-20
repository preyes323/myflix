require 'rails_helper'

RSpec.describe UsersController do
  describe 'GET new' do
    it 'sets @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST create' do
    context 'with valid input' do
      before do
        post :create, params: { user: Fabricate.attributes_for(:user) }
      end
      
      it 'creates the user' do
        expect(User.count).to eq(1)
      end
      
      it 'redirects to the root path' do
        expect(response).to redirect_to root_path
      end
    end
    
    context 'with invalid input' do
      before do
        post :create, params: { user: { password: '123456', full_name: 'foo bar' } }
      end
      
      it 'does not create the user' do
        expect(User.count).to eq(0)
      end
      
      it 'sets @user' do
        expect(assigns(:user)).to be_a_new(User)
      end
      
      it 'renders new template if invalid user' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET show/:id' do
    it_behaves_like 'require login' do
      let(:action) { get :show, params: { id: 3 } }
    end
    
    it 'sets @user' do
      alice = Fabricate(:user)
      set_current_user(alice)

      get :show, params: { id: alice.id }
      expect(assigns(:user)).to eq(alice)
    end
  end
end
