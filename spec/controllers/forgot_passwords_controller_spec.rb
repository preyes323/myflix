require 'rails_helper'

RSpec.describe ForgotPasswordsController do
  describe 'POST create' do
    context 'without user input' do
      it 'redirects to the forgot password page' do
        post :create, params: { email: '' }
        expect(response).to redirect_to forgot_passwords_path
      end
      
      it 'shows an error message' do
        post :create, params: { email: '' }
        expect(flash[:danger]).to_not be_nil
      end
    end
    
    context 'with existing email'
    context 'with non-existing email'    
  end

end
