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
        result.push(language.name)
      end
      
      result
  end
end
