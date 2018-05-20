class MyQueue < ApplicationRecord
  belongs_to :video
  belongs_to :user

  validates_uniqueness_of :position
  validates_presence_of :position
  validates_uniqueness_of :video_id, scope: :user_id
end
