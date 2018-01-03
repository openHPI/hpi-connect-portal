require 'rails_helper'

describe "employers/show" do
  before(:each) do
    @employer = assign(:employer, FactoryBot.create(:employer))
    allow(view).to receive(:can?) { false }
    allow(view).to receive(:signed_in?) { true }
    allow(view).to receive(:current_user) { FactoryBot.create(:user, :admin) }
  end
end
