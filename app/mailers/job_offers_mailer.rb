class JobOffersMailer < ActionMailer::Base
  default from: "hpi.hiwi.portal@gmail.com"
  layout "email"

  def new_job_offer_email(job_offer)
    @job_offer = job_offer
    mail(to: @job_offer.employer.deputy.email, subject: (t "job_offers_email.new_job_offer.subject"))
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

  def job_prolonged_email(job_offer)
    @job_offer = job_offer

    mail(to: 'hpi.hiwi.portal@gmail.com', subject: (t "job_offers_email.job_offer_prolonged.subject"))
  end

end
