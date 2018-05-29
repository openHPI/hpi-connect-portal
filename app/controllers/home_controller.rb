class HomeController < ApplicationController
  skip_before_filter :signed_in_user
  skip_before_filter :verify_authenticity_token

  def index
    @job_offers = JobOffer.active.last(5).reverse
    @employers = Employer.active.last(5).reverse
  end

  def admin_overview
    @job_offers = JobOffer.pending.where('created_at >= ?', 2.week.ago).order(created_at: :desc)
    @employers = Employer.pending.where('created_at >= ?', 2.week.ago).order(created_at: :desc)
    flash.now[:notice] = I18n.t('home.admin_overview.notice')
  end

  def imprint
  end

  def privacy
  end
end
