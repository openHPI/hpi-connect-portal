class HomeController < ApplicationController
  skip_before_filter :signed_in_user
  skip_before_filter :verify_authenticity_token

  authorize_resource only: [:admin_overview], class: false

  def index
    @job_offers = JobOffer.active.last(5).reverse
    @employers = Employer.active.last(5).reverse
  end

  def admin_overview
    @job_offers_pending_activation = JobOffer.pending.where('created_at >= ?', 2.week.ago).order(created_at: :desc)
    @job_offers_pending_prolongation = JobOffer.where('prolong_requested = true AND updated_at >= ?', 2.week.ago).order(created_at: :desc)
    @employers_pending_activation = Employer.pending.where('created_at >= ?', 2.week.ago).order(created_at: :desc)
    @employers_pending_package = Employer.where('requested_package_id != booked_package_id AND updated_at >= ?', 2.week.ago).order(created_at: :desc)
  end

  def imprint
  end

  def privacy
  end
end
