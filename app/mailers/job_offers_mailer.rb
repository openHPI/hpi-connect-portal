class JobOffersMailer < ActionMailer::Base
  default from: "hpi.hiwi.portal@gmail.com"

  def new_job_offer_email(job_offer)
  	@job_offer = job_offer
  	mail(to: @job_offer.employer.deputy.email, subject: (t "job_offers_email.new_job_offer.subject"))
  end

  def new_job_offer_info_email(job_offers, user)
    @job_offers = job_offers
    mail(to: user.email, subject: (t "job_offers_email.new_job_offer_info.subject"))
  end

  def deputy_accepted_job_offer_email(job_offer)
  	@job_offer = job_offer
  	mail(to: @job_offer.responsible_user.email, subject: (t "job_offers_email.job_offer_accepted.subject")+@job_offer.title)
  end

  def deputy_declined_job_offer_email(job_offer)
  	@job_offer = job_offer
  	mail(to: @job_offer.responsible_user.email, subject: (t "job_offers_email.job_offer_accepted.subject")+@job_offer.title)
  end

  def job_closed_email(job_offer)
    @job_offer = job_offer
    mail(to: 'hpi.hiwi.portal@gmail.com', subject: (t "job_offers_email.job_offer_closed.subject"))
  end

  def job_student_accepted_email(job_offer)
    @job_offer = job_offer

    mail(to: 'hpi.hiwi.portal@gmail.com', subject: (t "job_offers_email.student_accepted.subject"))
  end

  def inform_interested_students_immediately(job_offer)
    determine_interested_students(job_offer,User.update_immediately).each do |student|
      JobOffersMailer.new_job_offer_info_email([job_offer], student)
    end
  end

  def determine_interested_students(job_offer, students)
    students = students_by_chair(job_offer,students)
    students = students_by_programming_language(job_offer, students)
    students
  end

  def students_by_chair(job_offer, students)
    students = extract_students(EmployersNewsletterInformation.where("chair_id = ?",job_offer.chair.id), students)
  end

  def students_by_programming_language(job_offer, students)
    job_offer.programming_languages.each do |programming_language|
      studetns = extract_students(ProgrammingLanguagesNewsletterInformation.where("programming_language_id = ?", @programming_language.id), students)
    end
    students
  end

  def extract_students(iterable_newsletter_information, students)
    iterable_newsletter_information.each do |entry|
      students = students & User.find(id => entry.user_id)
    end
    students
  end

  def job_prolonged_email(job_offer)
    @job_offer = job_offer

    mail(to: 'hpi.hiwi.portal@gmail.com', subject: (t "job_offers_email.job_offer_prolonged.subject"))
  end
end
