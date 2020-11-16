# == Schema Information
#
# Table name: employers
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  description_de        :text
#  created_at            :datetime
#  updated_at            :datetime
#  avatar_file_name      :string(255)
#  avatar_content_type   :string(255)
#  avatar_file_size      :integer
#  avatar_updated_at     :datetime
#  activated             :boolean          default(FALSE), not null
#  place_of_business     :string(255)
#  website               :string(255)
#  line_of_business      :string(255)
#  year_of_foundation    :integer
#  number_of_employees   :string(255)
#  requested_package_id  :integer          default(0), not null
#  booked_package_id     :integer          default(0), not null
#  single_jobs_requested :integer          default(0), not null
#  token                 :string(255)
#  description_en        :text
#  package_booking_date  :date
#

class Employer < ApplicationRecord
  NUMBER_OF_EMPLOYEES_FIELDS = ["< 50", "50 - 100", "100 - 500", "500 - 1000", "> 1000"]
  PACKAGES = ['free', 'profile', 'partner', 'premium']

  has_attached_file :avatar, style: { medium: "200x200" }, default_url: "/assets/placeholder/:style/missing.png"

  has_one :contact, as: :counterpart, dependent: :destroy

  has_many :ratings, dependent: :destroy

  has_many :staff_members, class_name: 'Staff', dependent: :destroy
  has_many :job_offers, dependent: :destroy
  has_many :interested_students, class_name: 'Student', through: :employers_newsletter_information

  before_validation :generate_unique_token

  accepts_nested_attributes_for :staff_members
  accepts_nested_attributes_for :contact

  validates_attachment_size :avatar, less_than: 5.megabytes
  validates_attachment_content_type :avatar, content_type: ['image/jpeg', 'image/png']

  validates :name, presence: true, uniqueness: true
  validates :year_of_foundation, numericality: { only_integer: true,
    greater_than: 1800,
    less_than_or_equal_to: Time.now.year}, allow_nil: true

  scope :active, -> { where(activated: true) }
  scope :pending, -> { where(activated: false) }
  scope :paying, -> { where('booked_package_id >= ?', 1) }
  scope :order_by_name, -> { order(Arel.sql('LOWER(name)')) }
  scope :filter_employers, -> q { where("LOWER(name) LIKE ?", "#{q.downcase}%") }

  translates :description, fallback: :any

  def generate_unique_token
    code = SecureRandom.urlsafe_base64
    code = SecureRandom.urlsafe_base64 while Employer.exists? token: code
    self.token = code
  end

  def requested_package
    PACKAGES[requested_package_id]
  end

  def package
    PACKAGES[booked_package_id]
  end

  def paying?
    booked_package_id >= 1
  end

  def partner?
    booked_package_id >= 2
  end

  def premium?
    booked_package_id == 3
  end

  def package_expiring?
    begin
      self.paying? && self.package_booking_date + 1.year <= Date.today + 2.weeks
    rescue NoMethodError
      return nil
    end
  end

  def self.check_for_expired_package
    paying.each do |employer|
      begin
        if employer.package_booking_date + 1.year == Date.today + 2.weeks
          EmployersMailer.package_will_expire_email(employer).deliver_now
        elsif employer.package_booking_date + 1.year <= Date.today
          EmployersMailer.package_expired_email(employer).deliver_now
          employer.update_column :booked_package_id, 0
          employer.update_column :requested_package_id, 0
          employer.update_column :package_booking_date, nil
        end
      rescue StandardError => e
        logger.warn "Checking for expired packages failed for employer #{employer.name} and raised the exception #{e.class.name} : #{e.message}"

      end
    end
  end

  def graduate_job_count_this_year
    job_offers.graduate_jobs.where('extract(year from created_at) = ?', Date.today.year).length
  end

  def can_create_job_offer?(category)
    (category != 'graduate_job' || (partner? && graduate_job_count_this_year < (premium? ? 20 : 4))) ? true : false
  end

  def add_one_single_booked_job
    self.update_column :single_jobs_requested, self.single_jobs_requested+1
  end

  def remove_one_single_booked_job
    self.update_column :single_jobs_requested, self.single_jobs_requested-1
  end

  def average_rating
    if rating_amount > 0
      (Rating.where(employer: self).map{|x| x.score_overall}.reduce(:+) / rating_amount.to_f).round(1)
    end
  end

  def rating_amount
    Rating.where(employer: self).count
  end

  def self.export(registered_from, registered_to)
    CSV.generate(headers: true) do |csv|
      employer_attributes = %w{name}
      staff_member_attributes = %w{full_name email}
      contact_attributes = %w{street zip_city}
      headers = employer_attributes.map{ |attr| "employer_".concat(attr) }
      headers += staff_member_attributes.map{ |attr| "staff_member_".concat(attr) }
      headers += contact_attributes.map{ |attr| "contact_".concat(attr) }
      csv << headers
      csv = self.add_employers_to_csv(csv, employer_attributes, staff_member_attributes, contact_attributes, registered_from, registered_to)
    end
  end

  def self.add_employers_to_csv(csv, employer_attributes, staff_member_attributes, contact_attributes, registered_from, registered_to)
    Employer.find_each do |employer|
      if registered_from.nil? or (employer.created_at.to_date >= registered_from and employer.created_at.to_date <= registered_to)
        row = employer_attributes.map{ |attr| employer.send(attr) }

        staff_member = employer.staff_members.first
        row += staff_member_attributes.map{ |attr| staff_member.send(attr) }

        row += contact_attributes.map{ |attr| employer.contact.send(attr) } unless employer.contact.nil?

        csv << row
      end
    end
    return csv
  end
end
