class MyQueuesController < ApplicationController
  before_action :require_login
  
  def index
    @my_queues = current_user.my_queues
  end

  def create
    @my_queue = MyQueue.new video_id: params[:video], user: current_user, position: MyQueue.count + 1

    if @my_queue.save
      flash[:success] = 'Video was successfuly added to your queue'
      redirect_to my_queues_path
    else
      @video = Video.find params[:video]
      @video_review = VideoReview.new
      @reviews = VideoReview.where video_id: @video.id
      
      flash[:danger] = 'Video is already part of your queue'
      render 'videos/show'
    end
  end

  def update_queue
    params[:queue_items].each do |queue_item_data|
      queue_item = MyQueue.find queue_item_data['id']
      queue_item.update_attribute('position', queue_item_data['position'])
    end

    current_user.normalize_my_queue_positions

    redirect_to my_queues_path
  end
  
  def destroy
    queue_item = MyQueue.find(params[:id])
    queue_item.destroy if queue_item.user == current_user
    redirect_to my_queues_path
  end
end
