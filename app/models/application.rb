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

  def accept
    self.job_offer.assigned_students << self.user
    self.job_offer.update({vacant_posts: self.job_offer.vacant_posts - 1})
    ApplicationsMailer.application_accepted_student_email(self).deliver
    JobOffersMailer.job_student_accepted_email(self.job_offer).deliver
    if self.job_offer.vacant_posts == 0
      self.job_offer.update({status: JobStatus.running})
      Application.where(job_offer: self.job_offer).where.not(id: self.id).each do | application |
        application.decline
      end
    end
    self.delete
  end

  def decline
    ApplicationsMailer.application_declined_student_email(self).deliver
    self.delete
  end

end