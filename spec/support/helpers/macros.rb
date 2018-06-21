def set_current_user(user=nil)
  return session[:user] = user.id if user
  session[:user] = Fabricate(:user).id
end
