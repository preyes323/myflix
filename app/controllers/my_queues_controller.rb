class MyQueuesController < ApplicationController
  before_action :require_login
  
  def index
    @my_queues = MyQueue.all
  end

  def create
    @my_queue = MyQueue.new
    @video = Video.find params[:video]

   
end
