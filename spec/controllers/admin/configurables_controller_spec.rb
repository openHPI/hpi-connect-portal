require 'spec_helper'

describe Admin::ConfigurablesController do
  let(:admin) { FactoryGirl.create(:user, :admin) }
  render_views

  describe "validation" do 

    before(:each) do
      login admin
    end

    it "checks if an invalid email address is not saved" do
      get :show, { mailToAdministration: 'user@exam'}
      flash[:notice].should eq(I18n.t("errors.configuration.invalid_email"))
    end
  end
end
