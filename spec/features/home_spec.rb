require 'spec_helper'

describe "the home page" do 

  before(:all) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :active)
    FactoryGirl.create(:job_status, :closed)
  end

  it "renders the latest 5 job offers" do
    6.times { |i| FactoryGirl.create(:job_offer, title:"Testjob#{i+1}", status: JobStatus.active )}
    visit root_path
    page.should have_content(
      "Testjob2", "Testjob3", "Testjob4", "Testjob5", "Testjob6"
    )
    page.should_not have_content "Testjob1"
  end

  it "renders login for not signed in users" do
    visit root_path
    page.should have_content "Login"
    page.should have_css "#session_email"
  end

  it "renders login not for signed in users" do
    student = FactoryGirl.create(:student)
    login student.user
    visit root_path
    page.should_not have_content "Login"
  end

  it "does not render boxes if no latest employers and jobs" do
    visit root_path
    page.should_not have_css "#job_offers"
    page.should_not have_css "#employers"
  end

  it "renders the latest 3 employers" do
    4.times { |i| FactoryGirl.create(:employer, name:"TestEmployer#{i+1}") }
    visit root_path
    page.should have_content(
      "TestEmployer2", "TestEmployer3", "TestEmployer4"
    )
    page.should_not have_content "TestEmployer1"
  end

  it "finds link and fills in email" do
    visit root_path
    user = FactoryGirl.create(:user, email: "new_password_email@test.de")
    old_password = user.password
    find_link(I18n.t("devise.passwords.forgot_password")).click
    fill_in 'forgot_password_email', :with => '"new_password_email@test.de'
    click_on I18n.t("devise.passwords.request")
    current_path.should eq(root_path)      
    User.find(user).password.should_not eq(old_password)
  end   
end