class StudentsMailer < ActionMailer::Base
  default from: 'noreply-connect@hpi.de'

  def new_student_email(student)
    @student = student
    mail to: Configurable[:mailToAdministration], subject: t("students_mailer.new_student.subject")
  end
end
