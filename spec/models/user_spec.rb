require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should have_secure_password }
  it { should have_many(:my_queues).order('position ASC') }

  describe '#queued_video?' do
    it 'returns true when the user queued the video' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:my_queue, user: user, video: video)
      expect(user.queued_video?(video)).to be true
    end

    it 'returns false when then user has not queued the video' do
      user = Fabricate(:user)
      video = Fabricate(:video)            
      Fabricate(:my_queue, user: user)
      expect(user.queued_video?(video)).to be false
    end
  end

  describe '#can_follow?' do
    it 'returns true if the current user does not have following relationship with another user' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)

      expect(alice.can_follow?(bob)).to be true
    end
    
    it 'returns false if the current user has a following relationship with another user' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: alice)

      expect(alice.can_follow?(bob)).to be false
    end

    it 'returns false if the current user is the other user' do
      alice = Fabricate(:user)
      expect(alice.can_follow?(alice)).to be false
    end
  end
end
