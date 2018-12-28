require 'rails_helper'

feature 'User invites friend' do
  scenario 'User successfully invites friend and invitation is accepted' do
    alice = Fabricate(:user)
    sign_in(alice)

    invite_a_friend
    friend_accepts_invitation
    friend_signs_in
    
    click_link "People"
    expect(page).to have_content alice.full_name
    sign_out
    
    sign_in(alice)
    click_link "People"
    expect(page).to have_content "John Doe"

    clear_email
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "John Doe"
    fill_in "Friend's Email Address", with: "johndoe@example.com"
    fill_in "Invitation Message", with: "Hello, please join this site."
    click_button "Send Invitation"
    sign_out
  end

  def friend_accepts_invitation
    open_email("johndoe@example.com")
    current_email.click_link("Accept this invitation")

    fill_in "Password", with: '123456'
    fill_in "Full Name", with: "John Doe"
    click_button "Sign Up"    
  end

  def friend_signs_in
    visit login_path
    fill_in "Email Address", with: "johndoe@example.com"
    fill_in "Password", with: "123456"
    click_button "Login"
  end
end
