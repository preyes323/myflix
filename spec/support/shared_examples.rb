shared_examples 'require login' do
  it 'redirects to the login page' do
    session[:user] = nil
    action
    expect(response).to redirect_to(login_path)
  end
end
