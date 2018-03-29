require 'rails_helper'

RSpec.describe Video do
  let(:video) do
    Category.create name: 'Comedy'
    video = Video.new title: 'Monk', description: 'good video', category_id: Category.first.id
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
end
