require 'rails_helper'

RSpec.describe Category do
  it { should have_many(:videos) }

  context 'when loading recent videos' do
    it 'returns the 6 most recent vidoes in descending created at'
    it 'returns all videos if less than 6 in descending created at'
    context 'with the same created at' do
      it 'sorts by created at and then sorts alphabetically by title'
    end
  end
end
