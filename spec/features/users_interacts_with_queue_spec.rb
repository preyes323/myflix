require 'rails_helper'

feature 'User interacts with the queue' do
  scenario 'user adds and reorders video in the queue' do
    comedies = Fabricate(:category, name: 'Comedies')
    monk = Fabricate(:video, title: 'Monk', category: comedies)
    south_park = Fabricate(:video, title: 'South Park', category: comedies)
    futurama = Fabricate(:video, title: 'Futurama', category: comedies)

    sign_in
    click_video_on_homepage(monk)
    expect(page).to have_content monk.title

    click_link '+ My Queue'
    expect(page).to have_content monk.title

    visit video_path(monk)
    expect(page).not_to have_content '+ My Queue'

    visit home_path
    click_video_on_homepage(south_park)
    click_link '+ My Queue'

    visit home_path
    click_video_on_homepage(futurama)
    click_link '+ My Queue'

    find("input[data-video-id='#{monk.id}']").set(3)
    find("input[data-video-id='#{south_park.id}']").set(1)
    find("input[data-video-id='#{futurama.id}']").set(2)    

    click_button 'Update Instant Queue'

    expect(find("input[data-video-id='#{monk.id}']").value).to eq('3')
    expect(find("input[data-video-id='#{south_park.id}']").value).to eq('1')
    expect(find("input[data-video-id='#{futurama.id}']").value).to eq('2')
  end
end
