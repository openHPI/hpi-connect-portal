class JobOfferMailer < ActionMailer::Base
  default from: "monstar@hpi.uni-potsdam.de"

  def new_job_offers(user)
    @user = user
    mail(to: @user.email, subject: "New Job Offers")
  end
end