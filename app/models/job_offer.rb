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
	has_many :programming_languages
	accepts_nested_attributes_for :programming_languages
	validates :title, :description, :chair, :start_date, :time_effort, :compensation, presence: true
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

	def self.filter(params)
		query = JobOffer.all

   		query = query.where(:title => params[:title].split(',').collect(&:strip)) unless params[:title].nil? or params[:title].blank?
   		#puts query.to_yaml
    	query = query.where(:chair => params[:chair].split(',').collect(&:strip)) unless params[:chair].nil? or params[:chair].blank?
    	#puts query.to_yaml
   		query = query.where(:description => params[:description]) unless params[:description].nil? or params[:description].blank?
		#puts query.to_yaml
    	query = query.where('start_date > ?', Date.parse(params[:start_date])) unless params[:start_date].nil? or params[:start_date].blank?
    	query = query.where('end_date > ?', Date.parse(params[:end_date])) unless params[:end_date].nil? or params[:end_date].blank?
    	query = query.where('time_effort <= ?', params[:time_effort].to_f) unless params[:time_effort].nil? or params[:time_effort].blank?
    	query = query.where('compensation >= ?', params[:compensation].to_f) unless params[:compensation].nil? or params[:compensation].blank?
    	
    	return query
	end

end
