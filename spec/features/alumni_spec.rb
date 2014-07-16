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
  end
end