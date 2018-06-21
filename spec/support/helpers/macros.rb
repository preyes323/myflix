def set_current_user(user=nil)
  return session[:user] = user.id if user
  session[:user] = Fabricate(:user).id
end

def sign_in(a_user=nil)
  user = a_user || Fabricate(:user)
  visit login_path
  fill_in 'Email Address', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Login'
end
