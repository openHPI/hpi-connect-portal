module FeatureSessionHelper

  def login(user)
    FactoryBot.create(:job_status, :pending)
    FactoryBot.create(:job_status, :active)
    FactoryBot.create(:job_status, :closed)
    visit signin_path
    if page.has_link?('dropdown-toggle')
      page.click_link('dropdown-toggle')
      page.click_link "Log Out"
    end
    fill_in 'session_email', with: user.email
    fill_in 'session_password', with: 'password123'
    click_button 'Sign in'
  end

  def logout
    visit signin_path
    page.find('a.dropdown-toggle').click
    if page.has_link? "Log Out"
      page.click_link "Log Out"
    end
  end
end
