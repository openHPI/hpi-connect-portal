# == Schema Information
#
# Table name: staffs
#
#  id          :integer          not null, primary key
#  employer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Staff < ActiveRecord::Base

  has_one :user, as: :manifestation, dependent: :destroy

  validates :employer, presence: true
end
