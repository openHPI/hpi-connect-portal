module JobOfferScopes
  def self.included(job_offer)
    job_offer.class_eval  do
      scope :pending, -> { where(status_id: JobStatus.pending.id) }
      scope :open, -> { where(status_id: JobStatus.open.id) }
      scope :running, -> { where(status_id: JobStatus.running.id) }
      scope :completed, -> { where(status_id: JobStatus.completed.id) }
    end

    add_filter_and_search_scopes job_offer
  end

  def self.add_filter_and_search_scopes(job_offer)
    job_offer.class_eval do
      scope :filter_employer, -> employer { where(employer_id: employer) }
      scope :filter_category, -> category { where(category_id: category) }
      scope :filter_state, -> state { where(state_id: state) }
      scope :filter_graduation, -> graduation {where('graduation_id <= ?', graduation.to_f)}
      scope :filter_start_date, -> start_date { where('start_date >= ?', Date.parse(start_date)) }
      scope :filter_end_date, -> end_date { where('end_date <= ?', Date.parse(end_date)) }
      scope :filter_time_effort, -> time_effort { where('time_effort <= ?', time_effort.to_f) }
      scope :filter_compensation, -> compensation { where('compensation >= ?', compensation.to_f) }
      scope :filter_programming_languages, -> programming_language_ids { joins(:programming_languages).where('programming_languages.id IN (?)', programming_language_ids).uniq}
      scope :filter_languages, -> language_ids { joins(:languages).where('languages.id IN (?)', language_ids).uniq}
      scope :filter_external_employer_only, -> external_only { joins(:employer).where('employers.external = ?', true) }
      scope :search, -> search_string { includes(:programming_languages, :employer).where('lower(title) LIKE ? OR lower(job_offers.description) LIKE ? OR lower(employers.name) LIKE ? OR lower(programming_languages.name) LIKE ?', "%#{search_string}%".downcase, "%#{search_string}%".downcase, "%#{search_string}%".downcase, "%#{search_string}%".downcase).references(:programming_languages,:employer) }
    end
  end
end