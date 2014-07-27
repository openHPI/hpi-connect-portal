class EmployersMailer < ActionMailer::Base
  default from: 'noreply-connect@hpi.de'

  def new_employer_email(employer)
    @employer = employer
    mail to: Configurable[:mailToAdministration], subject: t("employers_mailer.new_employer.subject")
  end

  def book_package_email(employer)
    @employer = employer
    mail to: Configurable[:mailToAdministration], subject: t("employers_mailer.book_package.subject")
  end

  def requested_package_confirmation_email(employer)
    @employer = employer
    mail to: @employer.staff_members.map(&:email), subject: t("employers_mailer.confirm_request.subject")
  end

  def booked_package_confirmation_email(employer)
    @employer = employer
    mail to: @employer.staff_members.map(&:email), subject: t("employers_mailer.confirm_booking.subject")
  end

  def package_will_expire_email(employer)
    @employer = employer
    mail to: @employer.staff_members.map(&:email), subject: t("employers_mailer.package_will_expire.subject")
  end

  def package_expired_email(employer)
    @employer = employer
    mail to: @employer.staff_members.map(&:email), subject: t("employers_mailer.package_expired.subject")
  end

  def registration_confirmation(employer)
    @employer = employer
    employer.staff_members.each do |staff|
      @staff = staff
      mail(to: staff.email, subject: t("employers_mailer.registration_confirmation.subject")).deliver
    end
  end
end
