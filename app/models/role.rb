# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  level      :integer
#  created_at :datetime
#  updated_at :datetime
#

class Role < ActiveRecord::Base
	validates_uniqueness_of :name, :level
end
