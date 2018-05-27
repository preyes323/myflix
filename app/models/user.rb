class User < ApplicationRecord
  has_many :video_reviews
  has_many :my_queues, -> { order "position ASC" }
  validates_presence_of :email, :full_name, :password
  validates_uniqueness_of :email

  has_secure_password

  def normalize_my_queue_positions
    my_queues.each_with_index do |queue_item, idx|
      queue_item.update_attribute('position', idx + 1)
    end
  end
end
