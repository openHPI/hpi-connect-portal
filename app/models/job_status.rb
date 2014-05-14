# == Schema Information
#
# Table name: job_statuses
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class JobStatus < ActiveRecord::Base
  validates :name, uniqueness: { case_sensitive: false }, presence: true

  def self.pending
    where(name: 'pending').first
  end

  def self.active
    where(name: 'active').first
  end

  def self.closed
    where(name: 'closed').first
  end
end
