module FeatureSessionHelper

  def login(user) 
    FactoryGirl.create(:job_status, :active)
    visit signin_path
    if page.has_link? "Log Out"
      page.click_link "Log Out"
    end
    fill_in 'session_email', with: user.email
    fill_in 'session_password', with: 'password123'
    click_button 'Sign in'
  end
end