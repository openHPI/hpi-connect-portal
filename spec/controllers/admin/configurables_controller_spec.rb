require 'spec_helper'

describe Admin::ConfigurablesController do
  let(:admin) { FactoryGirl.create(:user, :admin) }
  render_views

  describe "validation" do 

    before(:each) do
      post '/signin', { session: { email: admin.email, password: 'password123' }}
    end
    
    it "checks if a valid email address is saved" do
      visit admin_configurable_path
      
      fill_in 'mailToAdministration', :with => 'user@example.com'
      click_on 'Save'

      find_field("mailToAdministration").value.should eq "user@example.com"
    end

    it "checks if an invalid email address is not saved" do
      get :show, {:mailToAdministration => 'user@exam'}
      flash[:notice].should eq(I18n.t("errors.configuration.invalid_email"))
    end
  end
end
