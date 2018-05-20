class MyQueuesController < ApplicationController
  before_action :require_login
  
  def index
    @my_queues = MyQueue.all
  end
end
