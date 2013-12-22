require 'spec_helper'


describe "the chair page" do

  before(:each) do
    @chair = FactoryGirl.create(:chair, name:"EPIC")
    @user = FactoryGirl.create(:user)

    @deputy = @chair.deputy
  end

  it "should show the basic information of the chair" do
  end

  it "should display open job offers for the chair" do
  end

  it "should display running jobs for the chair" do
  end

  # it "should include all jobs currently available" do
  #   visit job_offers_path
  #   page.should have_content(
  #     @job_offer_1.title,
  #     @job_offer_2.title,
  #     @job_offer_3.title
  #   )
  # end

 end
