require 'rails_helper'

describe "the user editing page" do

  before :each do
    @user = FactoryGirl.create :user
    login @user
  end

  it "should be possible to change attributes of myself " do
    visit edit_user_path(@user)
    fill_in 'user_email', with: 'test@gmail.com'
    find('input[value="Save"]').click

    expect(current_path).to eq(edit_user_path(@user))

    expect(page).to have_content(I18n.t('users.messages.account_successfully_updated'))
    expect(page).to have_content("Account Settings")
    expect(page).to have_selector("input[type=email][value='test@gmail.com']")

  end

  it "should be possible to change my password" do
    visit edit_user_path(@user)
    fill_in 'user_old_password', with: 'password123'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    find('input[value="Change Password"]').click

    expect(current_path).to eq(edit_user_path(@user))
    expect(page).to have_content(I18n.t('users.messages.password_changed'))
  end
end

describe "Login new Alumnus with old HPI Email adress" do
  it "should ask me to change my mail" do
    future_alumni = FactoryGirl.create(:student)
    future_alumni.user.update(email: "test@hpi-alumni.de")
    alumni = FactoryGirl.create(:alumni, firstname: future_alumni.firstname, lastname: future_alumni.lastname, alumni_email: "test")
    visit alumni_email_path(token: alumni.token)
    fill_in 'session_email', with: future_alumni.email
    fill_in 'session_password', with: 'password123'
    click_button I18n.t('home.index.sign_in')
    expect(current_path).to eq(edit_user_path(future_alumni.user))
    expect(page).to have_content I18n.t('alumni.choose_another_email')
  end
end

describe "Alumni data update" do
  before(:all) do
    require 'csv'
    FactoryGirl.create(:user, :alumnus, firstname: "Max", lastname: "Mustermann", alumni_email: "Max.Mustermann", email: "new@example.com")
  end

  it "returns an updated CSV file" do
    login FactoryGirl.create(:user, :admin)
    visit new_alumni_path
    file = File.join fixture_path, "csv/alumni_data_update_file.csv"
    find("#alumni_file_tbu").set(file)
    # Click second submit button
    find_all('input[type=submit]')[1].click

    header = page.response_headers['Content-Disposition']
    expect(header).to match /^attachment/
    expect(header).to match /filename="Alumni_aktualisiert-#{Date.today}.csv"$/
    expect(page.response_headers['Content-Type']).to eq "text/csv"
  end
end