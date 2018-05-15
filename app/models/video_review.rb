class VideoReview < ApplicationRecord
  belongs_to :user
  belongs_to :video

  validates_presence_of :rating, :review
  validates_uniqueness_of :user_id, scope: :video_id
  validates_inclusion_of :rating, in: 1..5

  def self.average_rating(video)
    video_ratings = ratings(video)
    return nil if video_ratings.count == 0

    video_ratings.reduce(:+) * 1.0 / video_ratings.count
  end

  def self.ratings(video)
    where(video_id: video.id).map(&:rating)
  end

  private_class_method :ratings
end
