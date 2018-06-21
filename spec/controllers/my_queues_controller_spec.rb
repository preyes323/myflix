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

    describe 'DELETE destroy' do
      before do
        @user = Fabricate(:user)
        video = Fabricate(:video)
        session[:user] = @user.id
        @my_queue = Fabricate(:my_queue, user: @user, video: video, position: 1)
      end
      
      it 'deletes video from queue' do
        delete :destroy, params: { id: @my_queue.id }
        expect(MyQueue.count).to eq(0)
      end
      
      it 'redirects back to index view' do
        delete :destroy, params: { id: @my_queue.id }
        expect(response).to redirect_to(my_queues_path)
      end

      it 'does not delete queue item if current user does not own it' do
        user2 = Fabricate(:user)
        queue_item2 = Fabricate(:my_queue, user: user2)
        delete :destroy, params: { id: queue_item2 }

        expect(MyQueue.count).to eq(2)
      end

      it 'normalizes the remaining queue items' do
        video2 = Fabricate(:video)
        queue_item2 = Fabricate(:my_queue, user: @user, video: video2, position: 2)

        delete :destroy, params: { id: @my_queue.id }
        expect(MyQueue.first.position).to eq(1)
      end
    end
    
    it 'redirects to login page with unauthenticated user' do
      video = Fabricate(:video)
      post :create, params: { video: video }
      expect(response).to redirect_to login_path
    end
  end

  describe 'POST update_queue' do
    context 'with valid input' do
      it 'redirects to the my queues page' do
        user1 = Fabricate(:user)
        session[:user] = user1.id
        queue_item1 = Fabricate(:my_queue, user: user1, position: 1)
        queue_item2 = Fabricate(:my_queue, user: user1, position: 2)

        post :update_queue, params: { queue_items:
                                     [{ id: queue_item1.id, position: 2 },
                                      { id: queue_item2.id, position: 1 }] }
        expect(response).to redirect_to(my_queues_path)
      end
      
      it 'reorders the queue items' do
        user1 = Fabricate(:user)
        session[:user] = user1.id
        queue_item1 = Fabricate(:my_queue, user: user1, position: 1)
        queue_item2 = Fabricate(:my_queue, user: user1, position: 2)

        post :update_queue, params: { queue_items:
                                     [{ id: queue_item1.id, position: 2 },
                                      { id: queue_item2.id, position: 1 }] }
        expect(user1.my_queues).to eq([queue_item2, queue_item1])        
      end
      
      it 'normalizes the position numbers' do
        user1 = Fabricate(:user)
        session[:user] = user1.id
        queue_item1 = Fabricate(:my_queue, user: user1, position: 1)
        queue_item2 = Fabricate(:my_queue, user: user1, position: 2)

        post :update_queue, params: { queue_items:
                                     [{ id: queue_item1.id, position: 3 },
                                      { id: queue_item2.id, position: 2 }] }
        expect(user1.my_queues.map(&:position)).to eq([1, 2])        
      end
    end
    
    context 'with invalid input' do
      it 'redirects to the my queue page' do
        user1 = Fabricate(:user)
        session[:user] = user1.id
        queue_item1 = Fabricate(:my_queue, user: user1, position: 1)
        queue_item2 = Fabricate(:my_queue, user: user1, position: 2)

        post :update_queue, params: { queue_items:
                                     [{ id: queue_item1.id, position: 2 },
                                      { id: queue_item2.id, position: 'a' }] }
        expect(response).to redirect_to(my_queues_path)
      end
      
      it 'sets the flash error message' do
        user1 = Fabricate(:user)
        session[:user] = user1.id
        queue_item1 = Fabricate(:my_queue, user: user1, position: 1)
        queue_item2 = Fabricate(:my_queue, user: user1, position: 2)

        post :update_queue, params: { queue_items:
                                     [{ id: queue_item1.id, position: 2 },
                                      { id: queue_item2.id, position: 'a' }] }
        expect(flash[:danger]).to_not be_nil
      end
      
      it 'does not change the queue items' do
        user1 = Fabricate(:user)
        session[:user] = user1.id
        queue_item1 = Fabricate(:my_queue, user: user1, position: 1)
        queue_item2 = Fabricate(:my_queue, user: user1, position: 2)

        post :update_queue, params: { queue_items:
                                     [{ id: queue_item1.id, position: 2 },
                                      { id: queue_item2.id, position: 'a' }] }
        expect(queue_item1.reload.position).to eq(1)
      end
    end
    
    context 'with unauthenticated users' do
      it 'redirects to login path' do
        user1 = Fabricate(:user)
        queue_item1 = Fabricate(:my_queue, user: user1, position: 1)
        queue_item2 = Fabricate(:my_queue, user: user1, position: 2)

        post :update_queue, params: { queue_items:
                                     [{ id: queue_item1.id, position: 2 },
                                      { id: queue_item2.id, position: 'a' }] }
        expect(response).to redirect_to(login_path)
      end
    end
    
    context 'with queue items that do not belong to the current user' do
      it 'does not change the queue items' do
        user1 = Fabricate(:user)
        session[:user] = user1.id
        user2 = Fabricate(:user)
        queue_item1 = Fabricate(:my_queue, user: user1, position: 1)
        queue_item2 = Fabricate(:my_queue, user: user2, position: 1)
        queue_item3 = Fabricate(:my_queue, user: user2, position: 2)

        post :update_queue, params: { queue_items:
                                     [{ id: queue_item1.id, position: 2 },
                                      { id: queue_item3.id, position: 1 }] }
        expect(queue_item3.reload.position).to eq(2)
      end
    end
  end
end
