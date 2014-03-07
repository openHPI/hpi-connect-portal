# == Schema Information
#
# Table name: applications
#
#  id           :integer          not null, primary key
#  student_id   :integer
#  job_offer_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Application do
  before(:each) do
    @application = Application.new(job_offer: FactoryGirl.create(:job_offer), user: FactoryGirl.create(:user))
  end

  subject { @application }

  it { should be_valid }

  describe "when job offer id is not present" do
    before { @application.job_offer_id = nil }
    it { should_not be_valid }
  end

  describe "when user id is not present" do
    before { @application.user_id = nil }
    it { should_not be_valid }
  end

  describe "another application" do
    it "with same job offer and user" do
      other_application = @application.dup
      other_application.save
      @application.should_not be_valid
    end
  end

end
