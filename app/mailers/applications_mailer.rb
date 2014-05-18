class ApplicationsMailer < ActionMailer::Base
  default from: 'hpi.hiwi.portal@gmail.com'
  
  def application_accepted_student_email(application)
    send_mail_for_application_to_user(application, (t "applications_mailer.students.accepted.subject", job_title: application.job_offer.title, employer: application.job_offer.employer.name))
  end

  def application_declined_student_email(application)
    send_mail_for_application_to_user(application, (t "applications_mailer.students.declined.subject", job_title: application.job_offer.title, employer: application.job_offer.employer.name))
  end
  
  def new_application_notification_email(application, message = t("applications_mailer.wimi.new_application.content"), add_cv = false, attached_files = nil)
    student = application.student
    cv = student.user.cv

    if (!cv.path.nil?) and !add_cv.nil?
      attachments[student.user.cv_file_name] = File.read(cv.path)
    end
    
    unless attached_files.nil?
      attached_files[:file_attributes].each do | file |
        attachments[file[:file].original_filename] = file[:file].tempfile
      end
    end

    send_mail_for_application_to_wimi(application, message, (t "applications_mailer.wimi.new_application.subject", job_title: application.job_offer.title))
  end

  private
    def send_mail_for_application_to_user(application, subject)
      @application = application
      mail(to: @application.student.email, subject: subject)
    end
    
    def send_mail_for_application_to_wimi(application, message, subject)
      @application = application
      @message = message
      mail(to: @application.job_offer.staff.email, subject: subject)
    end
end
