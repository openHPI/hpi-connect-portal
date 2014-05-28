require 'spec_helper'

describe "the user editing page" do

  before :all do
    FactoryGirl.create(:job_status, :active)
  end

  before :each do
    @user = FactoryGirl.create :user
    login @user
  end
  
  it "should be possible to change attributes of myself " do
    visit edit_user_path(@user)
    fill_in 'user_email', with: 'test@gmail.com'
    find('input[value="Save"]').click

    current_path.should == edit_user_path(@user)

    page.should have_content(
      I18n.t('users.messages.account_successfully_updated'),
      "Account Settings",
      "test@gmail.com"
    )
  end

  it "should be possible to change my password" do
    visit edit_user_path(@user)
    fill_in 'user_old_password', with: 'password123'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    find('input[value="Change Password"]').click

    current_path.should == edit_user_path(@user)
    page.should have_content(I18n.t('users.messages.password_changed'))
  end
end
