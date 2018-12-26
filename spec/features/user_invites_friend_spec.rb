require 'rails_helper'

feature 'User invites friend' do
  scenario 'User successfully invites friend and invitation is accepted' do
    alice = Fabricate(:user)
    sign_in(alice)

    visit new_invitation_path
    fill_in "Friend's Name", with: "John Doe"
    fill_in "Friend's Email Address", with: alice.email
    fill_in "Invitation Message", with: "Hello, please join this site."
    click_button "Send Invitation"

    open_email(alice.email)
    current_email.click("Accept this invitation")

    fill_in "Password", with: '123456'
    fill_in "Full  Name", with: "John Doe"
    click_button "Sign Up"

    fill_in "Email Address", with: alice.email
    fill_in "Password", with: "123456"
    click_button "Login"

    click_link "People"
    expect(page).to have_content alice.full_name
    sign_out
    
    sign_in(alice)
    click_link "People"
    expect(page).to have_content "John Doe"

    clear_email
  end
end
