class MyQueue < ApplicationRecord
  belongs_to :video
  belongs_to :user

  validates_uniqueness_of :position, scope: :user_id
  validates :position, presence: true, numericality: { only_integer: true }
  validates_uniqueness_of :video_id, scope: :user_id
end
