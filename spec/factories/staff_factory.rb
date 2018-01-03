# == Schema Information
#
# Table name: staffs
#
#  id          :integer          not null, primary key
#  employer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

FactoryBot.define do
  factory :staff do

    before(:create) do |staff|
      staff.user = FactoryBot.create(:user, manifestation: staff)
      staff.employer ||= FactoryBot.create(:employer)
    end
  end
end
