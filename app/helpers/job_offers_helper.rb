module JobOffersHelper
  def human_readable_start_date
    if @job_offer.flexible_start_date
      return t('job_offers.default_start_date')
    end
    @job_offer.start_date.to_s
  end

  def copy_employer_contact?(field)
    @job_offer.contact.method(field).nil? && signed_in_staff? && !current_user.manifestation.employer.nil? && !current_user.manifestation.employer.contact.nil?
  end
end
