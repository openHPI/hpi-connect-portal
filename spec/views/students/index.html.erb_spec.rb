require 'rails_helper'

describe "students/index" do
  before(:each) do
    @user_1 = FactoryGirl.create(:user)
    @user_2 = FactoryGirl.create(:user)
    assign(:users, [@user_1, @user_2])
  end
end
