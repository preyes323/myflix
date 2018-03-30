require 'rails_helper'

RSpec.describe Category do
  let(:category) do
    category = Category.new name: 'Comedy'
    category.save

    category
  end
  
  it 'saves itself' do
    expect(category).to eq(Category.first)
  end

  it 'has many videos' do
    relation = Category.reflect_on_association(:videos).macro

    expect(relation).to eq(:has_many)
  end
end
