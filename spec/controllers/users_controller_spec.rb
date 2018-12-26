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
 
     it 'makes the user follow the inviter' do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        post :create, params: { user: { email: 'joe@example.com', password: 'password', full_name: 'Joe Doe' }, invitation_token: invitation.token }
        joe = User.find_by_email 'joe@example.com'
        expect(joe.follows?(alice)).to be_truthy
     end
     
     it 'makes the inviter follow the user' do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        post :create, params: { user: { email: 'joe@example.com', password: 'password', full_name: 'Joe Doe' }, invitation_token: invitation.token }
        joe = User.find_by_email 'joe@example.com'
        expect(alice.follows?(joe)).to be_truthy       
     end
     
     it 'expires the invitation upon acceptance' do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        post :create, params: { user: { email: 'joe@example.com', password: 'password', full_name: 'Joe Doe' }, invitation_token: invitation.token }
        joe = User.find_by_email 'joe@example.com'
        expect(Invitation.first.token).to be_nil
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

    context 'sending email' do
      after { ActionMailer::Base.deliveries.clear }
      
      it 'sends out email to the user with valid input' do
        post :create, params: { user: { email: 'foo@bar.com', password: '123456', full_name: 'foo bar' }}
        expect(ActionMailer::Base.deliveries.last.to).to eq(['foo@bar.com'])
      end
      
      it 'sends out email containing the user\'s name with valid input' do
        post :create, params: { user: { email: 'foo@bar.com', password: '123456', full_name: 'foo bar' }}
        expect(ActionMailer::Base.deliveries.last.body).to include('foo bar')
      end
      
      it 'does not send email with invalid input' do
        post :create, params: { user: { password: '123456', full_name: 'foo bar' }}
        expect(ActionMailer::Base.deliveries).to be_empty
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

  describe 'GET new_with_invitation_token' do
    it 'renders :new template' do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, params: { token: invitation.token }
      expect(response).to render_template :new
    end
    
    it 'sets @user with recipients email' do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, params: { token: invitation.token }
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it 'sets @invitation_token' do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, params: { token: invitation.token }
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end
    
    it 'redirects to expired token page for invalid tokens' do
      get :new_with_invitation_token, params: { token: 'asdsad' }
      expect(response).to redirect_to expired_token_path
    end
  end
end
