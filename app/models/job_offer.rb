# == Schema Information
#
# Table name: job_offers
#
#  id          :integer          not null, primary key
#  description :string(255)
#  title       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class JobOffer < ActiveRecord::Base
	has_and_belongs_to_many :programming_languages
    has_and_belongs_to_many :languages
	accepts_nested_attributes_for :programming_languages
    accepts_nested_attributes_for :languages
	validates :title, :description, :chair, :start_date, :time_effort, :compensation, presence: true
    validates :compensation, :time_effort, numericality: true
	validates_datetime :end_date, :on_or_after => :start_date, :allow_blank => :end_date


	def self.sort(order_attribute) 
		if order_attribute == "date"
			order(:start_date)
		elsif order_attribute == "chair"
			order(:chair)
		end
	end

	def self.search(search_attribute)
			search_string = "%" + search_attribute + "%"
			search_string = search_string.downcase
			includes(:programming_languages).where('lower(title) LIKE ? OR lower(description) LIKE ? OR lower(chair) LIKE ? OR lower(programming_languages.name) LIKE ?', search_string, search_string, search_string, search_string).references(:programming_languages)
	end

	def self.filter(options={})
		all.filter_title(options[:title]).
        filter_chair(options[:chair]).
        filter_description(options[:description]).
        filter_start_date(options[:start_date]).
        filter_end_date(options[:end_date]).
        filter_time_effort(options[:time_effort]).
        filter_compensation(options[:compensation])
    end

    def self.filter_title(title)
    	if title.blank?
    		all
    	else
    		where(:title => title.split(',').collect(&:strip))
    	end
    end

    def self.filter_chair(chair)
    	if chair.blank?
    		all
    	else
    		where(:chair => chair.split(',').collect(&:strip))
    	end
    end

    def self.filter_description(description)
        if description.blank?
            all
        else
            where(:description => description)
        end
    end        

    def self.filter_start_date(start_date)
        if start_date.blank?
            all
        else
            where('start_date >= ?', Date.parse(start_date))
        end
    end        

    def self.filter_end_date(end_date)
        if end_date.blank?
            all
        else
            where('end_date <= ?', Date.parse(end_date))
        end
    end

    def self.filter_time_effort(time_effort)
        if time_effort.blank?
            all
        else
            where('time_effort <= ?', time_effort.to_f)
        end
    end

    def self.filter_compensation(compensation)
        if compensation.blank?
            all
        else
            where('compensation >= ?', compensation.to_f)
        end
    end
end
