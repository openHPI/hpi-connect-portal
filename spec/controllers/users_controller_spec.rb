require 'spec_helper'

describe UsersController do

 describe "POST forgot password" do

    before :each do
      @user = FactoryGirl.create :user
      @user.update_attributes(email: "user1@example.com")
    end   

    describe "stuff" do

    it "finds link and fills in email" do
      old_password = @user.password
      visit root_path
      find_link(I18n.t("devise.passwords.forgot_password")).click
      fill_in 'forgot_password_email', :with => 'user1@example.com'
      click_on I18n.t("devise.passwords.request")
      current_path.should == root_path      
      @user.reload.password.should_not eq(old_password)
    end    

    it "sends 1 email to the user" do
      ActionMailer::Base.deliveries.count==1   
      p ActionMailer::Base.deliveries[0]
      ActionMailer::Base.deliveries=[]
    end
  end

    it "posts forgot_password" do
      old_password = @user.password
      params = { forgot_password: { email: "user1@example.com" } }
      post :forgot_password, params
      response.should redirect_to(root_path)
      flash[:notice].should eq(I18n.t('devise.passwords.changed_password'))
      @user.reload
      ActionMailer::Base.deliveries.count==1  
      ActionMailer::Base.deliveries[0].should have_content(@user.reload.password)
      @user.reload.password.should_not eq(old_password)
    end

     it "sends 1 email to the user" do
      ActionMailer::Base.deliveries.count==1  
    end
  end 
end
