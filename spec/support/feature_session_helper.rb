module FeatureSessionHelper

  def login(user)
    visit signin_path
    #byebug
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
