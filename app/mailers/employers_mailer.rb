class EmployersMailer < ActionMailer::Base
  default from: 'hpi.hiwi.portal@gmail.com'

  def new_employer_email(employer)
    @employer = employer
    mail to: Configurable[:mailToAdministration], subject: t("employers_mailer.new_employer.subject")
  end

  def book_package_email(employer)
    @employer = employer
    mail to: Configurable[:mailToAdministration], subject: t("employers_mailer.book_package.subject")
  end
end
