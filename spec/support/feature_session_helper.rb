module FeatureSessionHelper

  def login(user) 
    visit '/signin'
    fill_in 'session_email', with: user.email
    fill_in 'session_password', with: 'password123'
    click_button 'Sign in'
  end
end