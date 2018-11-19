class Invitation < ApplicationRecord
  belongs_to :inviter, class_name: "User"

  validates_presence_of :recipient_name, :recipient_email
end
