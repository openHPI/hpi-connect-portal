class ApplicationsMailer < ActionMailer::Base
  default from: "hpi-hiwi-portal@hpi.uni-potsdam.de"

  def application_accepted_student_email(application)
  	send_mail_for_application(application, (t "applications_mailer.students.accepted.subject", job_title: application.job_offer.title, chair: application.job_offer.chair.name))
  end

  def application_declined_student_email(application)
    send_mail_for_application(application, (t "applications_mailer.students.declined.subject", job_title: application.job_offer.title, chair: application.job_offer.chair.name))
  end

  private
    def send_mail_for_application(application, subject)
        @application = application    
        mail(to: @application.user.email, subject: subject)
    end
end
