# == Schema Information
#
# Table name: newsletter_orders
#
#  id            :integer          not null, primary key
#  student_id    :integer
#  search_params :text
#  created_at    :datetime
#  updated_at    :datetime
#

class NewsletterOrder < ApplicationRecord
  belongs_to :student
  serialize :search_params
  validate :search_hash_cannot_be_nil
  validates :student, presence: true

  def search_hash_cannot_be_nil
    if search_params.nil?
      errors.add(:search_params, "can't be nil")
    end
  end
end
