require 'rails_helper'

describe "the home page" do

  it "renders the latest 5 job offers" do
    6.times { |i| FactoryGirl.create(:job_offer, title:"Testjob#{i+1}", status: JobStatus.active )}
    visit root_path
    expect(page).to have_content("Testjob2")
    expect(page).to have_content("Testjob3")
    expect(page).to have_content("Testjob4")
    expect(page).to have_content("Testjob5")
    expect(page).to have_content("Testjob6")
    expect(page).not_to have_content "Testjob1"
  end

  it "renders login for not signed in users" do
    visit root_path
    expect(page).to have_content "Login"
    expect(page).to have_css "#session_email"
  end

  it "renders login not for signed in users" do
    student = FactoryGirl.create(:student)
    login student.user
    visit root_path
    expect(page).not_to have_content "Login"
  end

  it "does not render boxes if no latest employers and jobs" do
    visit root_path
    expect(page).not_to have_css "#job_offers"
    expect(page).not_to have_css "#employers"
  end

  it "renders the latest 6 employers" do
    6.times { |i| FactoryGirl.create(:employer, name:"TestEmployer#{i+1}") }
    visit root_path
    expect(page).to have_content("TestEmployer2")
    expect(page).to have_content("TestEmployer3")
    expect(page).to have_content("TestEmployer4")
    expect(page).to have_content("TestEmployer5")
    expect(page).to have_content("TestEmployer6")
    expect(page).not_to have_content "TestEmployer1"
  end

  it "finds link and fills in email" do
    visit root_path
    user = FactoryGirl.create(:user, email: "new_password_email@test.de")
    old_password = user.password
    find_link(I18n.t("users.forgot_password")).click
    fill_in 'forgot_password_email', with: '"new_password_email@test.de'
    click_on I18n.t("users.request_password")
    expect(current_path).to eq(root_path)
    expect(User.find(user.id).password).not_to eq(old_password)
  end
end
