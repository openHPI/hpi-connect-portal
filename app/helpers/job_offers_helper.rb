module JobOffersHelper
  def human_readable_start_date
    if @job_offer.flexible_start_date
      return t('job_offers.default_start_date')
    end
    @job_offer.start_date.to_s
  end
end
