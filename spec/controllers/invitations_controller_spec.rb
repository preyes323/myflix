require 'rails_helper'

describe InvitationsController do
  describe 'GET new' do
    it 'sets @invitation to a new invitation' do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_a_new(Invitation)
    end

    it_behaves_like 'require login' do
      let(:action) { get :new }
    end
  end

  describe 'POST create' do
    it_behaves_like 'require login' do
      let(:action) { post :create }
    end

    context 'with valid input' do
      after { ActionMailer::Base.deliveries.clear }
      
      it 'redirects to the invitations/new page' do
        set_current_user
        post :create, params: { invitation: { recipient_name: 'Joe Smith', recipient_email: 'joe@example.com', message: 'Hey join Myflix' }}
        expect(response).to redirect_to(new_invitation_path)
      end
      
      it 'creates an invitation' do
        set_current_user
        post :create, params: { invitation: { recipient_name: 'Joe Smith', recipient_email: 'joe@example.com', message: 'Hey join Myflix' }}
        expect(Invitation.count).to eq(1)
      end
      
      it 'sends an email to the recipient' do
        set_current_user
        post :create, params: { invitation: { recipient_name: 'Joe Smith', recipient_email: 'joe@example.com', message: 'Hey join Myflix' }}
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end

      it 'sets the flash message' do
        set_current_user
        post :create, params: { invitation: { recipient_name: 'Joe Smith', recipient_email: 'joe@example.com', message: 'Hey join Myflix' }}
        expect(flash[:success]).to be_present
      end
    end
    
    context 'with invalid input' do
      after { ActionMailer::Base.deliveries.clear }
      
      it 'renders the :new template' do
        set_current_user
        post :create, params: { invitation: { recipient_email: 'joe@example.com', message: 'Hey join Myflix' }}
        expect(response).to render_template :new
      end
      
      it 'does not create an invitation' do
        set_current_user
        post :create, params: { invitation: { recipient_email: 'joe@example.com', message: 'Hey join Myflix' }}
        expect(Invitation.count).to eq(0)
      end
      
      it 'does not send out an email' do
        set_current_user
        post :create, params: { invitation: { recipient_email: 'joe@example.com', message: 'Hey join Myflix' }}
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      
      it 'sets the flash danger message' do
        set_current_user
        post :create, params: { invitation: { recipient_email: 'joe@example.com', message: 'Hey join Myflix' }}
        expect(flash[:danger]).to be_present
      end

      it 'sets the @invitation' do
        set_current_user
        post :create, params: { invitation: { recipient_email: 'joe@example.com', message: 'Hey join Myflix' }}
        expect(assigns(:invitation)).to be_a_new(Invitation)
      end
    end
  end
end
