require 'spec_helper'

describe "the alumni flow" do

  describe "creating alumni entries" do
    before :each do
      login FactoryGirl.create(:user, :admin)
      visit new_alumni_path
      Alumni.delete_all
      ActionMailer::Base.deliveries = []
    end

    it "should be possible to upload a csv file with alumni" do
      file = File.join fixture_path, "csv/alumni_file.csv"
      find("#alumni_file").set(file)
      first('input[type=submit]').click
      Alumni.count.should eq(3)
      ActionMailer::Base.deliveries.count.should == 3
    end

    it "should be possible to add single alumni" do
      fill_in 'alumni_firstname', with: 'Max'
      fill_in 'alumni_lastname', with: 'Mustermann'
      fill_in 'alumni_email', with: 'max@test.de'
      fill_in 'alumni_alumni_email', with: 'max@alumni.de'
      find('#new_alumni input[type=submit]').click
      Alumni.count.should eq(1)
      alumni = Alumni.last
      assert alumni.firstname == 'Max'
      assert alumni.lastname == 'Mustermann'
      assert alumni.email == 'max@test.de'
      assert alumni.alumni_email == 'max@alumni.de'
      assert !alumni.token.blank?
      ActionMailer::Base.deliveries.count.should == 1
    end
  end

  describe "send registration mail to alumni" do
    before :each do
      login FactoryGirl.create(:user, :admin)
      FactoryGirl.create(:alumni, alumni_email: "alexander.ernst")
      visit remind_via_mail_alumni_index_path
      ActionMailer::Base.deliveries = []
    end

    it "should be possible to upload a csv file to send mails" do
      file = File.join fixture_path, "csv/mail_file.csv"
      find("#email_file").set(file)
      first('input[type=submit]').click
      ActionMailer::Base.deliveries.count.should == 1
    end

    it "should not be possible for non_admin" do
      login FactoryGirl.create(:user)
      visit remind_via_mail_alumni_index_path
      current_path.should_not eq(remind_via_mail_alumni_index_path)
    end
  end

  describe "registering alumni addresses" do
    before :each do
      @alumni = FactoryGirl.create :alumni
      visit alumni_email_path(token: @alumni.token)
    end

    it "should be possible to add an alumni address to an existing account" do
      student = FactoryGirl.create :student
      fill_in 'session_email', with: student.email
      fill_in 'session_password', with: 'password123'
      click_button I18n.t('home.index.sign_in')
      current_path.should == student_path(student)
      student.reload
      assert student.alumni_email == @alumni.alumni_email
      assert student.activated
    end

    it "should be possible to add an alumni address to a new account" do
      page.should have_field('user_firstname', with: @alumni.firstname)
      page.should have_field('user_lastname', with: @alumni.lastname)
      page.should have_field('user_email', with: @alumni.email)
      fill_in 'user_password', with: 'password123'
      fill_in 'user_password_confirmation', with: 'password123'
      user_count = User.count
      student_count = Student.count
      click_button I18n.t('links.register')
      assert User.count == user_count + 1
      assert Student.count == student_count + 1
      assert Student.last.alumni_email == @alumni.alumni_email
      assert Student.last.activated
    end

    it "should not be possible to register a hpi-email adress" do
      page.should have_field('user_firstname', with: @alumni.firstname)
      page.should have_field('user_lastname', with: @alumni.lastname)
      page.should have_field('user_email', with: @alumni.email)
      fill_in 'user_email', with: 'thorsten.test@hpi-alumni.de'
      fill_in 'user_password', with: 'password123'
      fill_in 'user_password_confirmation', with: 'password123'
      user_count = User.count
      student_count = Student.count
      click_button I18n.t('links.register')
      assert User.count == user_count
      assert Student.count == student_count
      current_path.should eq(alumni_email_path(token: @alumni.token))
      fill_in 'user_email', with: 'thorsten.test@hpi.de'
      fill_in 'user_password', with: 'password123'
      fill_in 'user_password_confirmation', with: 'password123'
      click_button I18n.t('links.register')
      assert User.count == user_count
      assert Student.count == student_count
      current_path.should eq(alumni_email_path(token: @alumni.token))
      fill_in 'user_email', with: 'thorsten.test@student.hpi.uni-potsdam.de'
      fill_in 'user_password', with: 'password123'
      fill_in 'user_password_confirmation', with: 'password123'
      click_button I18n.t('links.register')
      assert User.count == user_count
      assert Student.count == student_count
      current_path.should eq(alumni_email_path(token: @alumni.token))
    end
  end
end

describe "the alumni index page" do
  it "renders an index page for admins" do
    alumni = FactoryGirl.create(:alumni, firstname: "Hans", lastname: "Peter")
    login FactoryGirl.create(:user, :admin)
    visit alumni_index_path
    click_link "Hans Peter"
    current_path.should eq(alumni_path(alumni))
  end
end

describe "Alumni Reminder Email" do

  it "sends mail" do
    mailer_count = Sidekiq::Extensions::DelayedMailer.jobs.size
    login FactoryGirl.create(:user, :admin)
    FactoryGirl.create(:alumni)
    visit remind_via_mail_alumni_index_path
    find("#remind-all-button").click
    Sidekiq::Extensions::DelayedMailer.jobs.size.should == mailer_count + 1
  end

end