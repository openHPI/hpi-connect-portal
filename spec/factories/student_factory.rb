# == Schema Information
#
# Table name: students
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  semester               :integer
#  academic_program       :string(255)
#  birthday               :date
#  education              :text
#  additional_information :text
#  homepage               :string(255)
#  github                 :string(255)
#  facebook               :string(255)
#  xing                   :string(255)
#  linkedin               :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  photo_file_name        :string(255)
#  photo_content_type     :string(255)
#  photo_file_size        :integer
#  photo_updated_at       :datetime
#  cv_file_name           :string(255)
#  cv_content_type        :string(255)
#  cv_file_size           :integer
#  cv_updated_at          :datetime
#  status                 :integer
#  student_status_id      :integer
#

FactoryGirl.define do
  factory :student do
    first_name 'Larry'
    last_name 'Ellison'
    education 'Master of Sailing'
    academic_program 'Volkswirtschaftslehre'
    homepage 'oracle.com'
    github 'larryAwesome'
    facebook 'larry2harry'
    xing 'theLarry'
    linkedin 'notHasso'
    languages {Language.create([{name: 'Englisch'}])}
    programming_languages  {ProgrammingLanguage.create([{ name: 'Ruby'}])}
  end
end
