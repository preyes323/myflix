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

  describe 'POST create' do
    context 'with authenticated user' do
      before do
        session[:user] = Fabricate(:user).id
      end
      
      it 'sets @my_queue' do
        video = Fabricate(:video)
        post :create, params: { video: video }

        expect(assigns(:my_queue)).to be_a_new(MyQueue)
      end
      
      it 'adds video to users queue' do
        video = Fabricate(:video)
        post :create, params: { video: video }

        expect(MyQueue.count).to eq(1)
      end
      
      it 'adds newly added video as last in queue by default'
      it 'redirects to videos index view on adding'      
    end

    it 'redirects to login page with unauthenticated user' do
      video = Fabricate(:video)
      post :create, params: { video: video }
      expect(response).to redirect_to login_path
    end
    
  end
end
