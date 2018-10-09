class User < ApplicationRecord
  has_many :video_reviews
  has_many :my_queues, -> { order "position ASC" }
  has_many :videos, through: :my_queues
  has_many :following_relationships, class_name: 'Relationship', foreign_key: 'follower_id'
  has_many :leading_relationships, class_name: 'Relationship', foreign_key: 'leader_id'
  validates_presence_of :email, :full_name, :password
  validates_uniqueness_of :email

  has_secure_password

  before_create :generate_token
  
  def normalize_my_queue_positions
    my_queues.each_with_index do |queue_item, idx|
      queue_item.update_attribute('position', idx + 1)
    end
  end

  def queued_video?(video)
    my_queues.map(&:video).include?(video)
  end

  def can_follow?(another_user)
    !following_relationships.map(&:leader).include?(another_user) &&
      self != another_user
  end

  private
  
  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end
