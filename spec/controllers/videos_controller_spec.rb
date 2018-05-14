require 'rails_helper'

RSpec.describe VideosController do
  describe 'GET show/:id' do
    it 'sets @video based on id for authenticated users' do
      session[:user] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, params: { id: video.id }
      expect(assigns(:video)).to eq(video)
    end
    
    it 'redirects to sign-in page for unauthenticated users' do
      video = Fabricate(:video)
      get :show, params: { id: video.id }
      expect(response).to redirect_to login_path
    end
  end
  
  describe 'GET search' do
    it 'sets @videos for authenticated uses based on :search_term' do
      session[:user] = Fabricate(:user).id      
      video = Fabricate(:video)
      get :search, params: { search_term: video.title }
      expect(assigns(:videos)).to eq([video])
    end

    it 'redirects to sign-in page for unauthenticated users' do
      video = Fabricate(:video)
      get :search, params: { search_term: video.title }      
      expect(response).to redirect_to login_path      
    end
  end
end
