# == Schema Information
#
# Table name: user_statuses
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class UserStatus < ActiveRecord::Base
	has_many :users
end
