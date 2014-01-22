# == Schema Information
#
# Table name: employers
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  head                :string(255)      not null
#  deputy_id           :integer
#  external            :boolean          default(FALSE)
#

class Employer < ActiveRecord::Base
  has_attached_file :avatar, :styles => { :medium => "200x200" }, :default_url => "/images/:style/missing.png"

  has_many :users
  has_many :job_offers
  belongs_to :deputy, class_name: "User"

  validates_attachment_size :avatar, :less_than => 5.megabytes
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png']

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :head, presence: true
  validates :deputy, presence: true

  scope :internal, -> { where(external: false) }
  scope :external, -> { where(external: true) }

  def staff
    User.where :employer => self
  end
end