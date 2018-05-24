class MyQueuesController < ApplicationController
  before_action :require_login
  
  def index
    @my_queues = MyQueue.where user: current_user
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
end
