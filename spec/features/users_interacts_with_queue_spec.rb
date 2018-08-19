require 'rails_helper'

feature 'User interacts with the queue' do
  scenario 'user adds and reorders video in the queue' do
    comedies = Fabricate(:category, name: 'Comedies')
    monk = Fabricate(:video, title: 'Monk', category: comedies)
    south_park = Fabricate(:video, title: 'South Park', category: comedies)
    futurama = Fabricate(:video, title: 'Futurama', category: comedies)

    sign_in
    find("a[href='/videos/#{monk.id}']").click
    expect(page).to have_content monk.title

    click_link '+ My Queue'
    expect(page).to have_content monk.title

    visit video_path(monk)
    expect(page).not_to have_content '+ My Queue'
  end
end
