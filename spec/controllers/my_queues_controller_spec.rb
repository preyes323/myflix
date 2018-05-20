require 'rails_helper'

RSpec.describe MyQueuesController do
  describe 'GET index' do
    it 'sets @my_queues' do
      session[:user] = Fabricate(:user).id
      get :index
      expect(assigns(:my_queues)).to eq(MyQueue.all)
    end
    
    it 'redirects to unauthenticated users to login page' do
      get :index
      expect(response).to redirect_to login_path
    end
  end
end
