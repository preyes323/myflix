class Category < ApplicationRecord
  has_many :videos

  def recent_videos
    videos.order(created_at: :desc, title: :asc).limit(6)
  end
end
