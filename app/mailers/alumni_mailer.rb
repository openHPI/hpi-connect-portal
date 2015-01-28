class AlumniMailer < ActionMailer::Base
  default from: "noreply-connect@hpi.de"

  def creation_email(alumni)
    @alumni = alumni
    mail to: alumni.email, subject: (t "alumni_mailer.creation_email.subject")
  end

  def reminder_email(alumni_id)
    @alumni_id = alumni_id
    mail to: Alumni.find(alumni_id).email, subject: (t "alumni_mailer.reminder.subject")
  end
end
