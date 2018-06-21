require 'rails_helper'

feature 'logging in' do
  given(:user) { Fabricate(:user) }

  scenario 'logging in with correct credentials' do
    visit login_path
    fill_in 'Email Address', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'
    
    expect(page).to have_content "Welcome, you've logged in."
  end

  scenario 'logging in with incorrect credentials' do
    visit login_path
    fill_in 'Email Address', with: user.email
    fill_in 'Password', with: ''
    click_button 'Login'

    save_and_open_page
    expect(page).to have_content 'There is something wrong with your username and password.'
  end  
end
