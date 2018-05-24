require 'rails_helper'

RSpec.describe MyQueuesController do
  describe 'GET index' do
    it 'sets @my_queues for the current user' do
      user = Fabricate(:user)
      session[:user] = user.id
      video1 = Fabricate(:my_queue, user: user)
      video2 = Fabricate(:my_queue, user: user)
      Fabricate(:my_queue)
      queue = [video1, video2]
      get :index
      
      expect(assigns(:my_queues)).to eq(queue)
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

        expect(assigns(:my_queue)).to be_instance_of(MyQueue)
      end
      
      it 'adds video to users queue' do
        video = Fabricate(:video)
        post :create, params: { video: video }

        expect(MyQueue.count).to eq(1)
      end
      
      it 'adds newly added video as last in queue by default' do
        video = Fabricate(:video)
        post :create, params: { video: video }
        video2 = Fabricate(:video)
        post :create, params: { video: video2 }

        expect(MyQueue.last.video).to eq(video2)
      end
      
      it 'redirects to my_queues index view on adding' do
        video = Fabricate(:video)
        post :create, params: { video: video }

        expect(response).to redirect_to(my_queues_path)
      end

      context 'with video already in the users queue' do
        let(:video) { Fabricate(:video) }
        
        before do
          @review = Fabricate(:video_review, video: video)
          post :create, params: { video: video }
          post :create, params: { video: video }          
        end
        
        it 're-renders video page if video is already in the users queue' do
          expect(response).to render_template('videos/show')
        end

        it 'sets @video if video is already in the users queue' do
          expect(assigns(:video)).to eq(video)
        end

        it 'sets @video_review' do
          expect(assigns(:video_review)).to be_a_new(VideoReview)
        end
        
        it 'sets @reviews' do
          expect(assigns(:reviews)).to eq([@review])
        end
      end
    end

    it 'redirects to login page with unauthenticated user' do
      video = Fabricate(:video)
      post :create, params: { video: video }
      expect(response).to redirect_to login_path
    end
    
  end
end
