class HomeController < ApplicationController
  skip_before_filter :signed_in_user
  skip_before_filter :verify_authenticity_token

  def index
    @job_offers = JobOffer.last 5
    @employers = Employer.last 3
  end

  def imprint
  end
end
