class AlumniMailer < ActionMailer::Base
  default from: "hpi.hiwi.portal@gmail.com"

  def creation_email(alumni)
    @alumni = alumni
    mail to: alumni.email, subject: (t "alumni_mailer.creation_email.subject")
  end
end
