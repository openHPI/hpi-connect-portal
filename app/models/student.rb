# == Schema Information
#
# Table name: students
#
#  id                     :integer          not null, primary key
#  semester               :integer
#  academic_program       :string(255)
#  education              :text
#  additional_information :text
#  birthday               :date
#  homepage               :string(255)
#  github                 :string(255)
#  facebook               :string(255)
#  xing                   :string(255)
#  linkedin               :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  employment_status_id   :integer          default(0), not null
#  frequency              :integer          default(1), not null
#  visibility_id          :integer          default(0), not null
#  academic_program_id    :integer          default(0), not null
#  graduation_id          :integer          default(0), not null
#

class Student < ActiveRecord::Base

	LINKEDIN_KEY = "77sfagfnu662bn"
	LINKEDIN_SECRET = "7HEaILeWfmauzlKp"
	LINKEDIN_CONFIGURATION = { :site => 'https://api.linkedin.com',
			:authorize_path => '/uas/oauth/authenticate',
			:request_token_path =>'/uas/oauth/requestToken?scope=r_basicprofile+r_fullprofile',
			:access_token_path => '/uas/oauth/accessToken' }

	VISIBILITYS = ['nobody','employers_only','employers_and_students','students_only']    
	ACADEMIC_PROGRAMS = ['bachelor', 'master', 'phd', 'alumnus']
	GRADUATIONS = ['abitur',  'bachelor', 'master', 'phd']
	EMPLOYMENT_STATUSES = ['jobseeking', 'employed', 'employedseeking', 'nointerest']
	DSCHOOL_STATUSES = ['nothing', 'introduction', 'basictrack', 'advancedtrack']

	attr_accessor :username

	has_one :user, as: :manifestation, dependent: :destroy

	has_many :applications, dependent: :destroy
	has_many :job_offers, through: :applications
	has_many :programming_languages_users, dependent: :destroy
	has_many :programming_languages, through: :programming_languages_users
	has_many :languages_users, dependent: :destroy
	has_many :languages, through: :languages_users
	has_many :assignments, dependent: :destroy
	has_many :assigned_job_offers, through: :assignments, source: :job_offer
	has_many :cv_jobs, dependent: :destroy
	has_many :cv_educations, dependent: :destroy

	accepts_nested_attributes_for :user, update_only: true
	accepts_nested_attributes_for :languages
	accepts_nested_attributes_for :programming_languages
	accepts_nested_attributes_for :cv_jobs, allow_destroy: true, reject_if: proc { |attributes| CvJob.too_blank? attributes }
	accepts_nested_attributes_for :cv_educations, allow_destroy: true, reject_if: proc { |attributes| CvEducation.too_blank? attributes }

	delegate :firstname, :lastname, :full_name, :email, :alumni_email, :activated, :photo, to: :user

	validates :academic_program_id, presence: true
	validates_inclusion_of :semester, in: 1..20, allow_nil: true

	scope :active, -> { joins(:user).where('users.activated = ?', true) }
	scope :visible_for_all, -> visibility_id { where('visibility_id < 0')}
	scope :visible_for_nobody, -> {where 'visibility_id = ?', VISIBILITYS.find_index('nobody')}
	scope :visible_for_students, -> {where 'visibility_id = ? or visibility_id = ?',VISIBILITYS.find_index('employers_and_students'),VISIBILITYS.find_index('students_only')} 
	scope :visible_for_employers, ->  { where('visibility_id > ? or visibility_id = ?', VISIBILITYS.find_index('employers_only'), VISIBILITYS.find_index('employers_and_students'))}
	scope :filter_semester, -> semester { where("semester IN (?)", semester.split(',').map(&:to_i)) }
	scope :filter_languages, -> language_ids { joins(:languages).where('languages.id IN (?)', language_ids).select("distinct students.*") }
	scope :filter_academic_program, -> academic_program_id { where('academic_program_id = ?', academic_program_id.to_f)}
	scope :filter_graduation, -> graduation_id { where('graduation_id >= ?', graduation_id.to_f)}
	scope :update_immediately, -> { where(frequency: 1) }
	scope :filter_students, -> q { joins(:user).where("
					(lower(firstname) LIKE ?
					OR lower(lastname) LIKE ?
					OR lower(email) LIKE ?
					OR lower(homepage) LIKE ?
					OR lower(github) LIKE ?
					OR lower(facebook) LIKE ?
					OR lower(xing) LIKE ?
					OR lower(linkedin) LIKE ?)
					",   q.downcase, q.downcase, q.downcase, q.downcase, q.downcase, q.downcase, q.downcase, q.downcase)}

	def self.filter_programming_languages(programming_language_ids)
		requested_programming_language_ids = programming_language_ids.map(&:to_i)
		fitting_student_ids = []
		Student.all.map { |student| {student_id: student.id, student_prog_langs: student.programming_languages} }.each { 
			|student_id_proglangs| 
				student_programming_languages_ids = student_id_proglangs[:student_prog_langs].map(&:id).map(&:to_i)
				if(requested_programming_language_ids.reject { |x| student_programming_languages_ids.include? x}.empty?)
					fitting_student_ids << student_id_proglangs[:student_id]
				end
			}
		where('"students"."id" IN (?)', fitting_student_ids)
	end

	def application(job_offer)
		applications.where(job_offer: job_offer).first
	end

	def applied?(job_offer)
		!!application(job_offer)
	end

	def employment_status
		EMPLOYMENT_STATUSES[employment_status_id]
	end

	def academic_program
		ACADEMIC_PROGRAMS[academic_program_id]
	end

	def graduation
		GRADUATIONS[graduation_id]
	end

	def visibility
		VISIBILITYS[visibility_id]
	end

	def dschool_status
		DSCHOOL_STATUSES[dschool_status_id]
	end

	def update_from_linkedin(linkedin_client)
		userdata = linkedin_client.profile(fields: ["public_profile_url", "languages", 
		"date-of-birth", "first-name", "last-name", "email-address", "skills", "three-current-positions", "positions", "honors-awards", "volunteer", "educations"])
		if !userdata["three-current-positions"].nil? && employment_status == "jobseeking"
			update!(employment_status_id: EMPLOYMENT_STATUSES.index("employedseeking"))
		end
		update_attributes!(
			{ birthday: userdata["date-of-birth"], 
				linkedin: userdata["public_profile_url"],
				user_attributes: {
					firstname: userdata["first-name"], 
					lastname: userdata["last-name"],
					email: userdata["email-address"]
				}.reject{|key, value| value.blank? || value.nil?}
			}.reject{|key, value| value.blank? || value.nil?})
		update_programming_language userdata["skills"]["all"] unless userdata["skills"].nil?
		update_cv_jobs userdata["positions"]["all"] unless userdata["positions"].nil?
		update_additional_information userdata["volunteer"], userdata["honors-awards"]
		update_educations userdata["educations"]["all"] unless userdata["educations"].nil?
	end

	def update_programming_language(skills)
		programming_language_names = (skills.reject{|skill_wrapper| ProgrammingLanguage.where(name: skill_wrapper["skill"]["name"]).empty? }).map{|programming_language_wrap| programming_language_wrap["skill"]["name"]}
		programming_language_names.each do |programming_language_name| 
			unless ProgrammingLanguagesUser.does_skill_exist_for_programming_language_and_student(ProgrammingLanguage.find_by_name(programming_language_name), self)
				ProgrammingLanguagesUser.create(student_id: self.id, programming_language_id: ProgrammingLanguage.find_by_name(programming_language_name).id, skill:3) 
			end
		end
	end

	def update_cv_jobs(jobs)   
		jobs.each do |job|
			description = !job["summary"].nil? ? job["summary"] : " " 
			start_date = !job["start_date"].nil? ? (!job["start_date"]["month"].nil? ? Date.new(job["start_date"]["year"].to_i, job["start_date"]["month"].to_i) : Date.new(job["start_date"]["year"].to_i)) : nil
			end_date = !job["end_date"].nil? ? (!job["end_date"]["month"].nil? ? Date.new(job["end_date"]["year"].to_i, job["end_date"]["month"].to_i) : Date.new(job["end_date"]["year"].to_i)) : nil
			current = (job["is_current"].to_s == 'true')
			update_attributes!(
				cv_jobs: self.cv_jobs.push(
					CvJob.new(
						student: self, 
						employer: job["company"]["name"], 
						position: job["title"], 
						description: description, 
						start_date: start_date, 
						end_date: end_date,
						current: current)
				)
			) 
		end
	end

	def update_additional_information(volunteers, awards)
		add_info = self.additional_information.nil? ? " " : self.additional_information
		if(!volunteers.nil?)
			add_info += "Volunteer-Experiences: "
			volunteers["volunteer-experiences"]["all"].each do |volunteer|
				add_info += "\n " + volunteer["role"] + " in " + volunteer["organization"]["name"] + " "
			end
		end
		if(!awards.nil?)
			add_info += "\n \n Awards: "
			awards["all"].each do |award|
				add_info += "\n " + award["name"] + " "
			end
		end
		update_attributes!( additional_information: add_info)
	end

	def update_educations(educations)
		educations.each do |education|

			degree = (!education["degree"].nil? ? education["degree"] : "No degree given")
			field = (!education["field-of-study"].nil? ? education["field-of-study"] : "No field-of-study given")
			start_date = !education["start_date"].nil? ? Date.new(education["start_date"]["year"].to_i, 1) : Date.new(Time.now.strftime("%Y").to_i, Time.now.strftime("%m").to_i)
			end_date = !education["end_date"].nil? ? Date.new(education["end_date"]["year"].to_i, 1) : Date.new(Time.now.strftime("%Y").to_i, Time.now.strftime("%m").to_i)
			current = end_date > Date.current
			update_attributes!(
				cv_educations: self.cv_educations.push(
					CvEducation.new(
						student: self, 
						degree: degree,            
						field: field, 
						institution: education["school-name"],
						start_date: start_date,
						end_date: end_date,
						current: current))
				)
			
		end
	end

	def self.linkedin_request_token_for_callback(url) 
		self.create_linkedin_client.request_token(oauth_callback: url)
	end

	def self.create_linkedin_client
		LinkedIn::Client.new(LINKEDIN_KEY, LINKEDIN_SECRET, LINKEDIN_CONFIGURATION)
	end
end
