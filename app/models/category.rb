class Category < ApplicationRecord
  has_many :videos

  def recent_videos
  end
end
