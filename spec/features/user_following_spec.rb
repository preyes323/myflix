require 'rails_helper'

RSpec.describe 'User following' do
  scenario 'user follows and unfollows someone' do
    alice = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    review = Fabricate(:video_review, user: alice, video: video)
    
    sign_in
    click_video_on_homepage(video)
    
    click_link alice.full_name
    click_link 'Follow'
    expect(page).to have_content(alice.full_name)

    unfollow
    expect(page).not_to have_content(alice.full_name)
  end

  def unfollow
    find("a[data-method='delete']").click    
  end
end
