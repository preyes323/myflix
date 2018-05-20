require 'rails_helper'

RSpec.describe MyQueue, type: :model do
  it { should belong_to(:video) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:position) }
  it { should validate_uniqueness_of(:video_id).scoped_to(:user_id) }
  it { should validate_uniqueness_of(:position).scoped_to(:user_id) }
end
  
