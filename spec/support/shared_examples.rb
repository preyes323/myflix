shared_examples 'require login' do
  it 'redirects to the login page' do
    session[:user] = nil
    action
    expect(response).to redirect_to(login_path)
  end
end

shared_examples 'tokenable' do
  it 'generates a random token when the user is created' do
    expect(object.token).to be_present
  end  
end
