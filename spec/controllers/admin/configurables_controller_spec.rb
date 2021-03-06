require 'rails_helper'

describe Admin::ConfigurablesController do
  let(:admin) { FactoryBot.create(:user, :admin) }
  render_views

  describe "validation" do

    before(:each) do
      login admin
    end

    it "checks if an invalid email address is not saved" do
      get :show, params: { mailToAdministration: 'user@exam' }
      expect(flash[:notice]).to eq(I18n.t("errors.configuration.invalid_email"))
    end
  end
end
