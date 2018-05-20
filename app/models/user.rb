class User < ApplicationRecord
  has_many :video_reviews
  has_many :my_queues, -> { order "position DESC" }
  validates_presence_of :email, :full_name, :password
  validates_uniqueness_of :email

  has_secure_password
end
