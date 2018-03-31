require 'rails_helper'

RSpec.describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  context 'when searching for videos by title' do
    let(:category) { Category.create name: 'Comedy' }

    it 'returns an empty array when there is no match' do
      result = Video.search_by_title 'Avengers'
      expect(result).to be_empty
    end
    
    it 'returns an array of Videos when there is a match' do
      video1 = Video.create(title: 'Monk',
                            description: 'movie',
                            category: category)
      video2 = Video.create title: 'Priest', description: 'movie', category: category
      result = Video.search_by_title 'Monk'

      expect(result).to include(video1)
    end

    it 'returns a match even when case is different' do
      video1 = Video.create title: 'Monk', description: 'movie', category: category
      video2 = Video.create title: 'monk', description: 'movie', category: category
      result = Video.search_by_title 'Monk'

      expect(result).to include(video1, video2)
    end
    
    it 'returns titles that are a partial match' do
      video1 = Video.create title: 'monkey', description: 'movie', category: category
      video2 = Video.create title: 'paramonk', description: 'movie', category: category
      video3 = Video.create title: 'monk', description: 'movie', category: category
      result = Video.search_by_title 'monk'

      expect(result).to include(video1, video2, video3)
    end

    it 'returns titles that are a partial match for the entire search term only' do
      video1 = Video.create title: 'money', description: 'movie', category: category
      video2 = Video.create title: 'paramonk', description: 'movie', category: category
      video3 = Video.create title: 'monk', description: 'movie', category: category
      result = Video.search_by_title 'monk'

      expect(result).to include(video2, video3)
    end

    it 'returns an empty array when search term is an empty string' do
      video1 = Video.create title: 'money', description: 'movie', category: category
      video2 = Video.create title: 'paramonk', description: 'movie', category: category
      result = Video.search_by_title ''

      expect(result).to be_empty
    end
  end
end
