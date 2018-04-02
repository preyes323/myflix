class Category < ApplicationRecord
  has_many :videos

  def recent_videos
    Video.where(category: self).order(created_at: :desc, title: :asc).limit(6)
  end
end
