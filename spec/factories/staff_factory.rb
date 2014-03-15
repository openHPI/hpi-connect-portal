# == Schema Information
#
# Table name: staffs
#
#  id          :integer          not null, primary key
#  employer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

FactoryGirl.define do
  factory :staff do

    before(:create) do |staff|
      staff.user = FactoryGirl.create(:user, manifestation: staff)
      staff.employer ||= FactoryGirl.create(:employer)
    end
  end
end
