require 'rails_helper'

RSpec.describe Category do
  it { should have_many(:videos) }

  context 'when loading recent videos' do
    before do
      @category = Category.create name: 'Comedy'
    end
    
    it 'returns the 6 most recent vidoes in descending created at' do
      v1 = Video.create title: 'monk', description: 'good movie', category: @category
      v2 = Video.create title: 'monk', description: 'good movie', category: @category
      v3 = Video.create title: 'monk', description: 'good movie', category: @category
      v4 = Video.create title: 'monk', description: 'good movie', category: @category
      v5 = Video.create title: 'monk', description: 'good movie', category: @category
      v6 = Video.create title: 'monk', description: 'good movie', category: @category
      v7 = Video.create title: 'monk', description: 'good movie', category: @category
      v8 = Video.create title: 'monk', description: 'good movie', category: @category

      results = @category.recent_videos
      expect(results).to eq([v8, v7, v6, v5, v4, v3, v2])
    end
    it 'returns all videos if less than or equal 6 videos exist in descending created at' do
      v1 = Video.create title: 'monk', description: 'good movie', category: @category
      v2 = Video.create title: 'monk', description: 'good movie', category: @category
      v3 = Video.create title: 'monk', description: 'good movie', category: @category

      results = @category.recent_videos
      expect(results).to eq([v3, v2, v1])
    end
    context 'with the same created at' do
      it 'sorts by created at and then sorts alphabetically by title' do
        v1 = Video.create title: 'mank', description: 'good movie', category: @category, created_at: 1.day.ago
        v2 = Video.create title: 'mink', description: 'good movie', category: @category, created_at: 1.day.ago
        v3 = Video.create title: 'monk', description: 'good movie', category: @category, created_at: 1.day.ago

        results = @category.recent_videos
        expect(results).to eq([v1, v2, v3])
      end
    end
  end
end
