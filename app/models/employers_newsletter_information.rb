# == Schema Information
#
# Table name: employers_newsletter_informations
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  employer_id :integer
#

class EmployersNewsletterInformation < ActiveRecord::Base
    belongs_to :employer
    belongs_to :user
end
