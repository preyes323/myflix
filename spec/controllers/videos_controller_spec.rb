require 'rails_helper'

RSpec.describe VideosController do
  describe 'GET show/:id' do
    let(:video) { Fabricate(:video) }

    context 'with authenticated user' do
      before do
        session[:user] = Fabricate(:user).id        
      end
      
      it 'sets @video based on id for authenticated users' do
        get :show, params: { id: video.id }
        expect(assigns(:video)).to eq(video)
      end

      it 'sets @reviews' do
        review = Fabricate(:video_review, video: video)
        get :show, params: { id: video.id }
        expect(assigns(:reviews)).to eq([review])
      end
      
      it 'sets @video_review' do
        get :show, params: { id: video.id }
        expect(assigns(:video_review)).to be_a_new(VideoReview)
      end
      
      it 'sets @average_rating to nil if no reviews' do
        get :show, params: { id: video.id }
        expect(assigns(:average_rating)).to be_nil
      end
      
      it 'formats @average_rating to one decimal place if not nil' do
        review1 = Fabricate(:video_review, video: video, rating: 3)
        review2 = Fabricate(:video_review, video: video, rating: 3)
        review3 = Fabricate(:video_review, video: video, rating: 3)
        
        get :show, params: { id: video.id }
        average_rating = "%.1f" % ((review1.rating + review2.rating + review3.rating) * 1.0 / 3)
        expect(assigns(:average_rating)).to eq(average_rating)
      end
    end
    
    it 'redirects to sign-in page for unauthenticated users' do
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

  describe 'POST review' do
    before do
      @user = Fabricate(:user)
      session[:user] = @user.id
    end
    
    it 'sets @video_review' do
      video = Fabricate(:video)
      post :review, params: { video_review: Fabricate.attributes_for(:video_review), id: video.id }, xhr: true
      expect(assigns(:video_review)).to be_instance_of(VideoReview)
    end
    
    it 'associates @video_review to logged in user' do
      video = Fabricate(:video)
      post :review, params: { video_review: Fabricate.attributes_for(:video_review), id: video.id }, xhr: true
      expect(VideoReview.first.user).to eq(@user)
    end
    
    it 'associates @video_review to video' do
      video = Fabricate(:video)
      post :review, params: { video_review: Fabricate.attributes_for(:video_review), id: video.id }, xhr: true
      expect(VideoReview.first.video).to eq(video)
    end
    
    it 'responds with js content for valid review' do
      video = Fabricate(:video)
      post :review, params: { video_review: Fabricate.attributes_for(:video_review), id: video.id }, xhr: true
      expect(response.content_type).to eq('text/javascript')
    end

    it 'informs user of successfully adding the review' do
      video = Fabricate(:video)
      post :review, params: { video_review: Fabricate.attributes_for(:video_review), id: video.id }, xhr: true
      expect(flash[:success]).to_not be_nil      
    end

    it 'informs user of missing detail for invalid review' do
      session[:user] = nil
      video = Fabricate(:video)
      post :review, params: { video_review: Fabricate.attributes_for(:video_review), id: video.id }, xhr: true
      expect(flash[:danger]).to_not be_nil
    end
  end
end
