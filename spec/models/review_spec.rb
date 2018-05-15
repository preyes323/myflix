require 'rails_helper'

RSpec.describe VideoReview do
  it { should validate_presence_of(:rating) }
  it { should validate_presence_of(:review) }
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  describe 'Saving a video review' do
    it 'adds the review' do
      review = Fabricate(:video_review)
      expect(VideoReview.count).to eq(1)
    end
    
    it 'allows a user to review multiple videos' do
      user = Fabricate(:user)
      review1 = Fabricate(:video_review, user: user)
      review2 = Fabricate(:video_review, user: user)

      expect(VideoReview.count).to eq(2)
    end

    it { should validate_inclusion_of(:rating).in_range(1..5) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:video_id) }
  end

  describe '.average_rating' do
    it 'returns nil if there are no ratings for a video' do
      video1 = Fabricate(:video)
      video2 = Fabricate(:video)
      review1 = Fabricate(:video_review, video: video1)
      review2 = Fabricate(:video_review, video: video1)

      expect(VideoReview.average_rating(video2)).to be_nil
    end
    
    it 'averages 1 count of rating' do
      video1 = Fabricate(:video)
      review1 = Fabricate(:video_review, video: video1, rating: 5)

      expect(VideoReview.average_rating(video1)).to eq(5)
    end
    
    it 'averages many ratings' do
      video1 = Fabricate(:video)
      review1 = Fabricate(:video_review, video: video1, rating: 5)
      review2 = Fabricate(:video_review, video: video1, rating: 3)
      review3 = Fabricate(:video_review, video: video1, rating: 3)

      average_rating = (review1.rating + review2.rating + review3.rating) * 1.0 / 3
      expect(VideoReview.average_rating(video1)).to eq(average_rating)
    end
  end
end
