require 'rails_helper'

RSpec.describe Video do
  let(:category) do
    Category.create name: 'Comedy'
  end
  
  let(:video) do
    video = Video.new title: 'Monk', description: 'good video', category: category
    video.save!

    video
  end
  
  it 'saves itself' do
    expect(video).to eq(Video.first)
  end

  it 'belongs to a Category' do
    relation = Video.reflect_on_association(:category).macro
    
    expect(relation).to eq(:belongs_to)
  end

  it 'does not save if there is no title' do
    video = Video.create description: 'good video', category: category
    expect(Video.count).to eq(0)
  end

  it 'does not save if there is no description' do
    video = Video.create title: 'Monk', category: category
    expect(Video.count).to eq(0)
  end
end
