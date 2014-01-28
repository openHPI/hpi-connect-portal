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

  def self.open
    where(name: 'open').first
  end

  def self.running
    where(name: 'running').first
  end

  def self.completed
    where(name: 'completed').first
  end
end
