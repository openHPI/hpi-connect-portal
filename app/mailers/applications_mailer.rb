class ApplicationsMailer < ActionMailer::Base
  default from: "hpi-hiwi-portal@hpi.uni-potsdam.de"

  def application_accepted_student_email(application)
  	send_mail_for_application_to_user(application, (t "applications_mailer.students.accepted.subject", job_title: application.job_offer.title, chair: application.job_offer.chair.name))
  end

  def application_declined_student_email(application)
    send_mail_for_application_to_user(application, (t "applications_mailer.students.declined.subject", job_title: application.job_offer.title, chair: application.job_offer.chair.name))
  end
  def new_application_notification_email(application, message, add_cv)
    if(!application.user.cv.path.nil?) and !add_cv.nil?
      attachments[application.user.cv_file_name] = File.read(application.user.cv.path)
    end
    send_mail_for_application_to_wimi(application, message, (t "applications_mailer.wimi.new_application.subject"))
  end

  private
    def send_mail_for_application_to_user(application, subject)
        @application = application    
        mail(to: @application.user.email, subject: subject)
    end
        def send_mail_for_application_to_wimi(application, message, subject)
        @application = application    
        @message = message
        mail(to: @application.job_offer.responsible_user.email, subject: subject)
    end
end
