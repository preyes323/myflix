class Video < ApplicationRecord
  belongs_to :category
  validates_presence_of :title, :description

  def self.search_by_title(title)
    return [] if title.blank?
    where("title ~* :title", title: title)
  end
end
