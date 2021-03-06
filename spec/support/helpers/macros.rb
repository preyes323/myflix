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

def sign_out
  visit logout_path
end

def click_video_on_homepage(video)
  find("a[href='/videos/#{video.id}']").click
end
