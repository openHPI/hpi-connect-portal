# == Schema Information
#
# Table name: job_offers
#
#  id                  :integer          not null, primary key
#  description         :text
#  title               :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  start_date          :date
#  end_date            :date
#  time_effort         :float
#  compensation        :float
#  room_number         :string(255)
#  chair_id            :integer
#  responsible_user_id :integer
#  status_id           :integer          default(1)
#  assigned_student_id :integer
#

class JobOffer < ActiveRecord::Base
    include Bootsy::Container
    before_save :default_values

    has_many :applications
    has_many :users, through: :applications
	has_and_belongs_to_many :programming_languages
    has_and_belongs_to_many :languages
    belongs_to :chair
    belongs_to :responsible_user, class_name: "User"
    belongs_to :assigned_student, class_name: "User"
    belongs_to :status, class_name: "JobStatus"

	accepts_nested_attributes_for :programming_languages
    accepts_nested_attributes_for :languages

	validates :title, :description, :chair, :start_date, :time_effort, :compensation, presence: true
    validates :compensation, :time_effort, numericality: true
	validates_datetime :end_date, :on_or_after => :start_date, :allow_blank => :end_date

    self.per_page = 5

    scope :pending, -> { where(status: JobStatus.pending) }
    scope :open, -> { where(status: JobStatus.open) }
    scope :running, -> { where(status: JobStatus.running) }
    scope :completed, -> { where(status: JobStatus.completed) }

    def default_values
        self.status ||= JobStatus.pending
    end

    def self.find_jobs(attributes={})

        result = all

        if !attributes[:search].blank?
            result = search(attributes[:search])
        end

        if !attributes[:filter].blank?
            result = result.filter(attributes[:filter])
        end

        if !attributes[:sort].blank?
            result = result.sort(attributes[:sort])
        else
            result = result.sort("date")
        end

        result
    end

	def self.sort(order_attribute) 
		if order_attribute == "date"
			order('job_offers.created_at DESC')
		elsif order_attribute == "chair"
			includes(:chair).order("chairs.name ASC")
		end
	end

	def self.search(search_attribute)
			search_string = "%" + search_attribute + "%"
			search_string = search_string.downcase
			includes(:programming_languages,:chair).where('lower(title) LIKE ? OR lower(job_offers.description) LIKE ? OR lower(chairs.name) LIKE ? OR lower(programming_languages.name) LIKE ?', search_string, search_string, search_string, search_string).references(:programming_languages,:chair)
	end

	def self.filter(options={})

		filter_chair(options[:chair]).
        filter_start_date(options[:start_date]).
        filter_end_date(options[:end_date]).
        filter_time_effort(options[:time_effort]).
        filter_compensation(options[:compensation]).
        filter_status(options[:status]).
        filter_programming_languages(options[:programming_language_ids]).
        filter_languages(options[:language_ids])
    end


    def self.filter_chair(chair)
    	chair.blank? ? all : where(chair_id: chair.to_i)             
    end

    def self.filter_start_date(start_date)
        start_date.blank? ? all : where('start_date >= ?', Date.parse(start_date))
    end        

    def self.filter_end_date(end_date)
        end_date.blank? ? all : where('end_date <= ?', Date.parse(end_date))
    end

    def self.filter_time_effort(time_effort)
        time_effort.blank? ? all : where('time_effort <= ?', time_effort.to_f)
    end

    def self.filter_compensation(compensation)
        compensation.blank? ? all : where('compensation >= ?', compensation.to_f)
    end

    def self.filter_status(status)
        status.blank? ? all: where(status: status)
    end

    def self.filter_programming_languages(programming_language_ids)
        if programming_language_ids.blank?
            all
        else
            joins(:programming_languages).where('programming_languages.id IN (?)', programming_language_ids).select("distinct job_offers.*")
        end
    end

    def self.filter_languages(language_ids)
        if language_ids.blank?
            all
        else
             joins(:languages).where('languages.id IN (?)', language_ids).select("distinct job_offers.*")
        end
    end

    def completed?
        status == JobStatus.completed
    end

    def pending?
        status == JobStatus.pending
    end

    def open?
        status == JobStatus.open
    end

    def running?
        status == JobStatus.running
    end

    def editable?
        self.pending? or self.open?
    end
end
