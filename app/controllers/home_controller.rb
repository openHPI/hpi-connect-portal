class HomeController < ApplicationController
  skip_before_filter :signed_in_user
  skip_before_filter :verify_authenticity_token

  def index
    @job_offers = JobOffer.active.last 5
    @employers = Employer.active.last 3
  end

  def imprint
  end
end
