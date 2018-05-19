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

  def review
    @video = Video.find params[:id]
    video_review = params[:video_review]
    @video_review = VideoReview.create user: current_user, video: @video, rating: video_review[:rating], review: video_review[:review]

    if @video_review.valid?
      flash.now[:success] = 'Your review was added.'
    else
      flash.now[:danger] = 'There was a problem adding your review.'
    end
    
    respond_to do |format|
      format.js
    end
  end
end
