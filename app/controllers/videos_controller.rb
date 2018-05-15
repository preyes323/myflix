class VideosController < ApplicationController
  before_action :require_login
  
  def index
    @categories = Category.all
  end

  def show
    @video = Video.find params[:id]
    @video_review = VideoReview.new
    @reviews = VideoReview.where(video_id: @video.id)
    @average_rating = "%.1f" % VideoReview.average_rating(@video) if @reviews.count > 0
  end

  def search
    @videos = Video.search_by_title params[:search_term]
  end
end
