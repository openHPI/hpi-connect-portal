class Chair < ActiveRecord::Base
  belongs_to :user, foreign_key: :head_of_chair
	has_attached_file :avatar, :styles => { :medium => "200x200" }, :default_url => "/images/:style/missing.png"

  validates_attachment_size :avatar, :less_than => 5.megabytes
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png']
	validates :name, presence: true, uniqueness: true
	validates :description, presence: true
end
