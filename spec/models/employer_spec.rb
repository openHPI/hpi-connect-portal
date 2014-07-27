# == Schema Information
#
# Table name: employers
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  description           :text
#  created_at            :datetime
#  updated_at            :datetime
#  avatar_file_name      :string(255)
#  avatar_content_type   :string(255)
#  avatar_file_size      :integer
#  avatar_updated_at     :datetime
#  activated             :boolean          default(FALSE), not null
#  place_of_business     :string(255)
#  website               :string(255)
#  line_of_business      :string(255)
#  year_of_foundation    :integer
#  number_of_employees   :string(255)
#  requested_package_id  :integer          default(0), not null
#  booked_package_id     :integer          default(0), not null
#  single_jobs_requested :integer          default(0), not null
#

require 'spec_helper'

describe Employer do
  before(:each) do
    @employer = FactoryGirl.create(:employer)
  end

  describe "validation of parameters" do

    it "with name not present" do
      @employer.name = nil
      @employer.should be_invalid
    end

    it "with name is not unique" do
      employer_with_same_name = @employer.dup
      assert employer_with_same_name.should be_invalid
    end

    it "with year_of_foundation less than 1800" do
      @employer.year_of_foundation = 1745
      @employer.should be_invalid
    end

    it "with year_of_foundation greater than 1800" do
      @employer.year_of_foundation = 1801
      @employer.should be_valid
    end

    it "with future year_of_foundation" do
      @employer.year_of_foundation = Time.now.year + 1
      @employer.should be_invalid
    end
  end

  describe 'expiration' do

    before :each do
      Employer.delete_all
      @paying_employer_reference = FactoryGirl.create(:employer, booked_package_id: 1, booked_at: Date.today)
      ActionMailer::Base.deliveries = []
    end

    it "sends an email 1 week before expiration" do
      @employer_warning = FactoryGirl.create(:employer, booked_package_id: 1, booked_at: Date.today - 1.year + 1.week)
      Employer.check_for_expired
      ActionMailer::Base.deliveries.count.should eq(1)
      email = ActionMailer::Base.deliveries[0]
      assert_equal(email.to, @employer_warning.staff_members.collect(&:email))
    end

    it "sends an email on expiration and resets the booked package" do
      @employer_expire = FactoryGirl.create(:employer, booked_package_id: 1, booked_at: Date.today - 1.year)
      Employer.check_for_expired
      ActionMailer::Base.deliveries.count.should eq(1)
      email = ActionMailer::Base.deliveries[0]
      assert_equal(email.to, @employer_expire.staff_members.collect(&:email))
      assert_equal(@employer_expire.reload.booked_package_id, 0)
      assert_equal(@employer_expire.reload.requested_package_id, 0)
    end

    it "does only check for expiration of paying employers" do
      @employer_expire = FactoryGirl.create(:employer, booked_package_id: 0, booked_at: Date.today - 2.year)
      Employer.check_for_expired
      ActionMailer::Base.deliveries.count.should eq(0)
    end
  end
end
