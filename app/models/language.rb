class Language < ActiveRecord::Base
	has_and_belongs_to_many :students
	validates_uniqueness_of :name
end
