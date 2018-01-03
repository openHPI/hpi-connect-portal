require 'rails_helper'

describe "students/index" do
  before(:each) do
    @user_1 = FactoryBot.create(:user)
    @user_2 = FactoryBot.create(:user)
    assign(:users, [@user_1, @user_2])
  end
end
