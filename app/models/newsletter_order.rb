class NewsletterOrder < ActiveRecord::Base
  belongs_to :student
  serialize :search_params
  validates :search_params, presence: true
end
