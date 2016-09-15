# == Schema Information
#
# Table name: alumnis
#
#  id                        :integer          not null, primary key
#  firstname                 :string(255)
#  lastname                  :string(255)
#  email                     :string(255)      not null
#  alumni_email              :string(255)      not null
#  token                     :string(255)      not null
#  created_at                :datetime
#  updated_at                :datetime
#  hidden_title              :string(255)
#  hidden_birth_name         :string(255)
#  hidden_graduation_id      :integer
#  hidden_graduation_year    :integer
#  hidden_private_email      :string(255)
#  hidden_alumni_email       :string(255)
#  hidden_additional_email   :string(255)
#  hidden_last_employer      :string(255)
#  hidden_current_position   :string(255)
#  hidden_street             :string(255)
#  hidden_location           :string(255)
#  hidden_postcode           :string(255)
#  hidden_country            :string(255)
#  hidden_phone_number       :string(255)
#  hidden_comment            :string(255)
#  hidden_agreed_alumni_work :string(255)
#

FactoryGirl.define do
  factory :alumni do
    firstname               'Max'
    lastname                'Mustermann'
    sequence(:email)        { |n| "user_#{n}@example.com" }
    sequence(:alumni_email) { |n| "user_#{n}" }
    sequence(:token)        { |n| SecureRandom.urlsafe_base64 + "#{n}" }
  end
end
