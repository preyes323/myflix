class MyQueue < ApplicationRecord
  belongs_to :video
  belongs_to :user

  validates :position, presence: true, numericality: { only_integer: true }
  validates_uniqueness_of :video_id, scope: :user_id

  delegate :category, to: :video
  delegate :title, to: :video, prefix: true
  
  def rating
    video_review.rating if video_review
  end

  def category_name
    category.name
  end

  def rating=(new_rating)
    if video_review
      video_review.update_column(:rating, new_rating)
    else
      review = VideoReview.new(user: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end

  def video_review
    @review ||= video.video_reviews.find_by(video_id: video.id)
  end
end
