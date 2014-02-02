module UserScopes

  def self.included(user)
    user.class_eval do
      scope :students, -> { joins(:role).where('roles.name = ?', 'Student') }
      scope :staff, -> { joins(:role).where('roles.name = ?', 'Staff') }

      scope :update_immediately, ->{ joins(:role).where('frequency = ? AND roles.name= ?', 1, 'Student') }
    end

    add_filter_and_search_scopes user
  end

  def self.add_filter_and_search_scopes(user)
    user.class_eval do
      scope :filter_semester, -> semester { where("semester IN (?)", semester.split(',').map(&:to_i)) }
      scope :filter_programming_languages, -> programming_language_ids { joins(:programming_languages).where('programming_languages.id IN (?)', programming_language_ids).select("distinct users.*") }
      scope :filter_languages, -> language_ids { joins(:languages).where('languages.id IN (?)', language_ids).select("distinct users.*") }
      scope :search_students, -> string { where("
                  (lower(firstname) LIKE ?
                  OR lower(lastname) LIKE ?
                  OR lower(email) LIKE ?
                  OR lower(academic_program) LIKE ?
                  OR lower(education) LIKE ?
                  OR lower(homepage) LIKE ?
                  OR lower(github) LIKE ?
                  OR lower(facebook) LIKE ?
                  OR lower(xing) LIKE ?
                  OR lower(linkedin) LIKE ?)
                  ",
                  string.downcase, string.downcase, string.downcase, string.downcase, string.downcase,
                  string.downcase, string.downcase, string.downcase, string.downcase, string.downcase) }
    end
  end
end