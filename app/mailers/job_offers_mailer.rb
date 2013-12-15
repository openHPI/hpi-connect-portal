class JobOffersMailer < ActionMailer::Base
  default from: "hpi-hiwi-portal@hpi.uni-potsdam.de"

  def new_job_offer_email(job_offer)
  	@job_offer = job_offer
  	mail(to: @job_offer.chair.deputy.email, subject: (t "job_offers_email.new_job_offer_subject"))
  end

  def deputy_accepted_job_offer_email(job_offer)
  	@job_offer = job_offer

  	mail(to: @job_offer.responsible_user.email, subject: (t "job_offers_email.job_offer_accepted.subject")+@job_offer.title)
  end

  def deputy_declined_job_offer_email(job_offer)
  	@job_offer = job_offer

  	mail(to: @job_offer.responsible_user.email, subject: (t "job_offers_email.job_offer_accepted.subject")+@job_offer.title)
  end

end
