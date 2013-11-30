# == Schema Information
#
# Table name: chairs
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  head_of_chair       :string(255)      not null
#  deputy_id           :integer
#

class Chair < ActiveRecord::Base
  	has_attached_file :avatar, :styles => { :medium => "200x200" }, :default_url => "/images/:style/missing.png"

    has_many :users
    belongs_to :deputy, :class_name => "User"

  	validates_attachment_size :avatar, :less_than => 5.megabytes
  	validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png']

	validates :name, presence: true, uniqueness: true
	validates :description, presence: true
	validates :head_of_chair, presence: true
    validates :deputy, presence: true
end
