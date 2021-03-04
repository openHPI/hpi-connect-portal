class StudentsMailer < ActionMailer::Base
  default from: 'noreply-connect@hpi.de'
  helper ApplicationHelper

  def new_student_email(student)
    @student = student
    mail to: Configurable[:mailToAdministration], subject: t("students_mailer.new_student.subject")
  end

  def newsletter(student, job_offers, newsletter_order)
    @student = student
    @job_offers = job_offers
    @newsletter_order = newsletter_order
    mail to: student.email, subject: t("students_mailer.newsletter.subject")
  end
end
