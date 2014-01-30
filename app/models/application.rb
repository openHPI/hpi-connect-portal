# == Schema Information
#
# Table name: applications
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  job_offer_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Application < ActiveRecord::Base
  belongs_to :user
  belongs_to :job_offer

  validates_presence_of :user
  validates_presence_of :job_offer
  validates_uniqueness_of :user_id, scope: :job_offer_id

  def decline
    ApplicationsMailer.application_declined_student_email(self).deliver
    self.delete
  end

end