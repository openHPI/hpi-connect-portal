require 'spec_helper'

describe UsersController do
  let(:student) { FactoryGirl.create(:student) }
  let(:staff) { FactoryGirl.create(:staff) }
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:employer) { FactoryGirl.create(:employer) }
  let(:default_params) { {format: :json, exclude_user: admin.to_param} }

  let(:valid_session) { {} }

  describe "GET edit" do
    pending
  end

  describe "PUT update" do
    pending
  end
end
