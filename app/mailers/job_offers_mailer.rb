class JobOffersMailer < ActionMailer::Base
  default from: "hpi-hiwi-portal@hpi.uni-potsdam.de"

  def new_job_offer_email(job_offer)
  	@job_offer = job_offer
  	mail(to: @job_offer.chair.deputy.email, subject: "A new job offer is pending.")
  end
end
