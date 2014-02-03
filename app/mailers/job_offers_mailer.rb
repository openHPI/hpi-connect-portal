class JobOffersMailer < ActionMailer::Base
  default from: 'hpi.hiwi.portal@gmail.com'
  layout "email"

  def new_job_offer_email(job_offer)
    @job_offer = job_offer
    mail(to: @job_offer.employer.deputy.email, subject: (t "job_offers_mailer.new_job_offer.subject"))
  end

  def new_job_offer_info_email(job_offers, user)
    @job_offers = job_offers
     mail(to: user.email, subject: (t "job_offers_mailer.new_job_offer_info.subject"))
  end

  def deputy_accepted_job_offer_email(job_offer)
    @job_offer = job_offer
    mail(to: @job_offer.responsible_user.email, subject: (t "job_offers_mailer.job_offer_accepted.subject")+@job_offer.title)
  end

  def deputy_declined_job_offer_email(job_offer)
    @job_offer = job_offer
    mail(to: @job_offer.responsible_user.email, subject: (t "job_offers_mailer.job_offer_accepted.subject")+@job_offer.title)
  end

  def job_closed_email(job_offer)
    @job_offer = job_offer
    mail(to: Configurable[:mailToAdministration], subject: (t "job_offers_mailer.job_offer_closed.subject"))
  end

  def job_student_accepted_email(job_offer)
    @job_offer = job_offer
    mail(to: Configurable[:mailToAdministration], subject: (t "job_offers_mailer.student_accepted.subject"))
  end

  def job_prolonged_email(job_offer)
    @job_offer = job_offer
    mail(to: Configurable[:mailToAdministration], subject: (t "job_offers_mailer.job_offer_prolonged.subject"))
  end

  def inform_interested_students_immediately(job_offer)
    determine_interested_students(job_offer,User.update_immediately).each do |student|
      JobOffersMailer.new_job_offer_info_email([job_offer], student).deliver
    end
  end

  def determine_interested_students(job_offer, students)
    students_by_employer(job_offer,students).to_set + students_by_programming_language(job_offer, students).to_set
   end

  def students_by_employer(job_offer, students)
    employer_students = EmployersNewsletterInformation.where(employer: job_offer.employer).map(&:user)
    students & employer_students
  end

  def students_by_programming_language(job_offer, students)
    students & job_offer.programming_languages.map{ |programming_language|
      ProgrammingLanguagesNewsletterInformation.where("programming_language_id = ?", @programming_language.id).map(&:user)}
  end
end
