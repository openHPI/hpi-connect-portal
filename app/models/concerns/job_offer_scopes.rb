module JobOfferScopes
  def self.included(job_offer)
    job_offer.class_eval  do
      scope :pending, -> { where(status_id: JobStatus.pending.id) }
      scope :active, -> { where(status_id: JobStatus.active.id) }
      scope :closed, -> { where(status_id: JobStatus.closed.id) }
      scope :graduate_jobs, -> { where(category_id: 2) }
    end

    add_filter_and_search_scopes job_offer
  end

  def self.add_filter_and_search_scopes(job_offer)
    job_offer.class_eval do
      scope :filter_employer, -> employer { where(employer_id: employer) }
      scope :filter_category, -> category { where(category_id: category) }
      scope :filter_state, -> state { where(state_id: state) }
      scope :filter_student_group, -> student_group { if student_group == Student.group_id('hpi').to_s
                                                        where("student_group_id = ? OR student_group_id = ?", Student.group_id('hpi'), Student.group_id('both'))
                                                      elsif student_group == Student.group_id('dschool').to_s
                                                        where("student_group_id = ? OR student_group_id = ?", Student.group_id('dschool'), Student.group_id('both'))
                                                      elsif student_group == Student.group_id('both').to_s
                                                        where("student_group_id = ? OR student_group_id = ? OR student_group_id = ?", Student.group_id('hpi'), Student.group_id('dschool'), Student.group_id('both'))
                                                      elsif student_group == Student.group_id('hpi_grad').to_s
                                                        where("student_group_id = ?", Student.group_id('hpi_grad'))
                                                      end
                                                    }
      scope :filter_graduation, -> graduation {where('graduation_id <= ?', graduation.to_f)}
      scope :filter_start_date, -> start_date { where('start_date >= ?', Date.parse(start_date)) }
      scope :filter_end_date, -> end_date { where('end_date <= ?', Date.parse(end_date)) }
      scope :filter_time_effort, -> time_effort { where('time_effort <= ?', time_effort.to_f) }
      scope :filter_compensation, -> compensation { where('compensation >= ?', compensation.to_f) }
      scope :filter_programming_languages, -> programming_language_ids { joins(:programming_languages).where('programming_languages.id IN (?)', programming_language_ids).distinct}
      scope :filter_languages, -> language_ids { joins(:languages).where('languages.id IN (?)', language_ids).distinct}
      scope :search, -> search_string { includes(:programming_languages, :employer).where('lower(title) LIKE ? OR lower(job_offers.description_de) LIKE ? OR lower(job_offers.description_en) LIKE ? OR lower(employers.name) LIKE ? OR lower(programming_languages.name) LIKE ?', "%#{search_string}%".downcase, "%#{search_string}%".downcase, "%#{search_string}%".downcase, "%#{search_string}%".downcase, "%#{search_string}%".downcase).references(:programming_languages,:employer) }
    end
  end
end
