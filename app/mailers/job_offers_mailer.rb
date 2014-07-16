class JobOffersMailer < ActionMailer::Base
  default from: 'hpi.hiwi.portal@gmail.com'
  layout "email"

  def new_job_offer_email(job_offer)
    @job_offer = job_offer
    mail to: Configurable[:mailToAdministration], subject: (t "job_offers_mailer.new_job_offer.subject", job_title: @job_offer.title)
  end

  def new_job_offer_info_email(job_offer, user)
    @job_offer = job_offer
    @student = user
    mail to: user.email, subject: (t "job_offers_mailer.new_job_offer_info.subject")
  end

  def admin_accepted_job_offer_email(job_offer)
    @job_offer = job_offer
    @job_offer.employer.staff_members.each do |staff| 
      @staff = staff
      mail(to: staff.email, subject: (t "job_offers_mailer.job_offer_accepted.subject", job_title: @job_offer.title))
    end
  end

  def admin_declined_job_offer_email(job_offer)
    @job_offer = job_offer
    @job_offer.employer.staff_members.each do |staff| 
      @staff = staff
      mail(to: staff.email, subject: (t "job_offers_mailer.job_offer_declined.subject", job_title: @job_offer.title)) 
    end
  end

  def job_closed_email(job_offer)
    @job_offer = job_offer
    mail to: Configurable[:mailToAdministration], subject: (t "job_offers_mailer.job_offer_closed.subject", job_title: @job_offer.title)
  end

  def job_student_accepted_email(job_offer)
    @job_offer = job_offer
    mail to: Configurable[:mailToAdministration], subject: (t "job_offers_mailer.student_accepted.subject", job_title: @job_offer.title)
  end

  def job_prolonged_email(job_offer)
    @job_offer = job_offer
    job_offer.employer.staff_members.each do |staff| 
      @staff = staff
      mail to: staff.email, subject: (t "job_offers_mailer.job_offer_prolonged.subject", job_title: @job_offer.title) 
    end
  end

  def prolong_requested_email(job_offer)
    @job_offer = job_offer
    mail to: Configurable[:mailToAdministration], subject: (t "job_offers_mailer.prolong_requested.subject", job_title: @job_offer.title)
  end

  def job_will_expire_email(job_offer)
    @job_offer = job_offer
    emails = job_offer.employer.staff_members.collect(&:email).join(',')
    mail to: emails, subject: (t "job_offers_mailer.job_offer_will_expire.subject", job_title: @job_offer.title)
  end

  def job_expired_email(job_offer)
    @job_offer = job_offer
    job_offer.employer.staff_members.each do |staff| 
      @staff = staff
      mail to: staff.email, subject: (t "job_offers_mailer.job_offer_expired.subject") 
    end
  end

  def inform_interested_students_immediately(job_offer)
    determine_interested_students(job_offer, Student.update_immediately).each do |student|
      JobOffersMailer.new_job_offer_info_email(job_offer, student).deliver
    end
  end

  def determine_interested_students(job_offer, students)
    students_by_employer(job_offer,students).to_set + students_by_programming_language(job_offer, students).to_set
   end

  def students_by_employer(job_offer, students)
    employer_students = EmployersNewsletterInformation.where(employer: job_offer.employer).map(&:student)
    students & employer_students
  end

  def students_by_programming_language(job_offer, students)
    students & job_offer.programming_languages.map{ |programming_language|
      ProgrammingLanguagesNewsletterInformation.where("programming_language_id = ?", programming_language.id).map(&:student)}
  end
end
