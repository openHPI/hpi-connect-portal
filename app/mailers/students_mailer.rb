class StudentsMailer < ActionMailer::Base
  default from: 'hpi.hiwi.portal@gmail.com'

  def new_student_email(student)
    @student = student
    mail to: Configurable[:mailToAdministration], subject: t("students_mailer.new_student.subject")
  end
end
