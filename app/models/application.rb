# == Schema Information
#
# Table name: applications
#
#  id           :integer          not null, primary key
#  student_id   :integer
#  job_offer_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Application < ActiveRecord::Base
  
  belongs_to :student
  belongs_to :job_offer

  validates_presence_of :student
  validates_presence_of :job_offer
  validates_uniqueness_of :student_id, scope: :job_offer_id

  def self.create_and_notify(job_offer, student, params)
    application = Application.new job_offer: job_offer, student: student
    if application.save
      ApplicationsMailer.new_application_notification_email(application, params[:message], params[:add_cv], params[:attached_files]).deliver
      true
    else
      false
    end
  end

  def decline
    ApplicationsMailer.application_declined_student_email(self).deliver
    self.delete
  end
end
