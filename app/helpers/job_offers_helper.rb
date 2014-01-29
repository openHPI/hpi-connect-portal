module JobOffersHelper
	def get_programming_language_names
      result = []
      @job_offer.programming_languages.each do |programming_language|
        result.push(programming_language.name)
      end

      result
  end

  def get_language_names
      result = []
      @job_offer.languages.each do |language|
        result.push(t("languages." +  language.name))
      end

      result
  end

  def human_readable_start_date
    if @job_offer.flexible_start_date
      return t('job_offers.default_start_date')
    end

    @job_offer.start_date.to_s
  end
end
